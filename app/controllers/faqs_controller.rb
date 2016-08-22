class FaqsController < ApplicationController

  before_filter :load_faq, only: [:edit, :update, :destroy, :show]
  load_and_authorize_resource except: [:create, :search]

  layout "promotions_layout", only: [:index]

  ##
  # GET /faqs
  def index
    @faqs = Faq.all.order(question: :asc).page(params[:page])
  end

  ##
  # GET /faqs/search
  def search
    @faqs = Faq.search(params[:query]).order(question: :asc).page(params[:page])
    respond_to do |format|
      format.js
    end
  end

  ##
  # GET /faqs/new
  def new
    @faq = Faq.new
  end

  ##
  # POST /faqs
  def create
    authorize! :manage, Faq
    @faq = Faq.new(faq_params)

    if @faq.save
      redirect_to faqs_path
    else
      render "new"
    end
  end

  ##
  # GET /faqs/:id
  def edit
  end

  ##
  # PUT /faqs/:id
  def update
    if @faq.update(faq_params)
      redirect_to faqs_path
    else
      render "edit"
    end
  end

  ##
  # DELETE /faqs/:id
  def destroy
    @faq.destroy
    redirect_to faqs_path
  end

  ##
  # GET /faqs/:id
  def show
  end

  private
    def faq_params
      params.require(:faq).permit(:question, :answer)
    end

    def load_faq
      @faq = Faq.find_by_id(params[:id])
    end
end
