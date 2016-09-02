class ActivitiesController < ApplicationController
  before_filter :load_activities, only: [:show, :cus_month_calendars,:view_day]
  before_filter :load_book, only: [:booked]
  skip_before_action :authenticate_user!
  skip_before_action :load_activities, only: [:show]
  before_filter :load_current_user

  def index
    if params[:popular].eql?("true")
      @promotions = Promotion.get_total_booking.filter(params_query).page(params[:page])
    else
      @promotions = Promotion.includes(:images).filter(params_query).page(params[:page]).order(discount_percent: :desc, discount_price: :desc, created_at: :asc)
    end
  end

  def genre
    @categories = Category.all
    respond_to do |format|
      format.html
      format.json { render :json => @categories }
    end
  end

  def show
    @activity = Promotion.find(params[:id])
  end


  private
  def load_current_user
    if user_signed_in?
      gon.current_user_id = current_user.id
      gon.current_user_name = current_user.email
    else
      gon.current_user_name = false
    end
  end

  def params_query
    params["criteria"].nil? ? {} : JSON.parse(params["criteria"])
  end
end