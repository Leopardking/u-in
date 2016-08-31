class ActivitiesController < ApplicationController
  before_filter :load_activities, only: [:show, :cus_month_calendars,:view_day]
  before_filter :load_book, only: [:booked]
  skip_before_action :authenticate_user!
  skip_before_action :load_activities, only: [:show]

  def index
    if params[:popular].eql?("true")
      @promotions = Promotion.get_total_booking.filter(params_query).page(params[:page])
    else
      @promotions = Promotion.filter(params_query).page(params[:page]).order(discount_percent: :desc, discount_price: :desc, created_at: :asc)
    end
    respond_to do |format|
      format.html
      format.json { render :json => {activities: @promotions, next_page: @promotions.next_page} }
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
    h = Hash.new
    h["promotion"]  = @activity
    h["images"]     = @activity.images.map { |v| v.image.url(:medium)}
    if @activity.end_date.present?
      h["space"]      = PromotionService.new.show_space(@activity, @activity.start_date, @activity.end_date, @activity.id, nil)
    end
    
    @activity = h
    respond_to do |format|
      format.html
      format.json { render :json => @activity }
    end
  end


  private
  def params_query
    params["criteria"].nil? ? {} : JSON.parse(params["criteria"])
  end
end