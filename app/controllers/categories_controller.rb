class CategoriesController < ApplicationController
  before_filter :load_category, only: [:destroy, :delete, :edit]
  def index
    authorize! :admin, Category
    if !params[:name].blank?
      @categories = Category.where(["LOWER(name) like ?", "%#{params[:name].downcase}%" ]).order("name ASC").page(params[:page])
    else
      @categories = Category.order("name ASC").page(params[:page])
    end
  end
  ##
  #
  def create
    authorize! :write, Category
    if params[:suggest_category]
      data = {}
      data[:first_name] = params_category[:first_name]
      data[:last_name] = params_category[:last_name]
      data[:suggest_catr] = params_category[:suggest_catr]
      data[:date_time] = Time.zone.now.to_date
      data[:email] = params_category[:email]
      UserMailer.delay.send_suggest_new_category_to_admin(data)
    else
      category = current_user.categories.new(name: params[:category][:name])
      if category.save
        flash.now[:notice]= t("categories.categories.created_succesfull")
      end
    end
  end
  ##
  #
  def edit
    authorize! :admin, Category
  end
  def update
    authorize! :admin, Category
    @category = Category.find(params[:id])
    unless Category.where.not(id: params[:id]).find_by_name(params[:category][:name])
      if @category.update(update_category_params)
        flash[:notice]= t("categories.update.update_successfull")
      else
        flash[:error]= t("categories.update.update_fail")
      end
    else
      flash[:error]= t("categories.update.update_exist")
    end
  end
  ##
  #GET
  def delete
    authorize! :admin, Category
  end
  # DELETE
  def destroy
    authorize! :admin, Category
    if !@category.blank?
      if @category.destroy
        flash[:notice]= t("categories.delete.destroy_successfull")
      end
    end
  end
  ##
  # JS CHECK Category Name
  def check_categories_unique
    authorize! :read, Category
    @category = Category.find_by_name(params[:category][:name])
    render :json => !@category
  end
  ##
  # Private
  private
    def load_category
      @category = Category.find_by_id(params[:id])
    end
    def update_category_params
      params.require(:category).permit(:name)
    end
    def params_category
      params.require(:category).permit(:first_name,:last_name,:company_name,:email,:suggest_catr)
    end
end
