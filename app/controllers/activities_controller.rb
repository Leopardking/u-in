class ActivitiesController < ApplicationController
  before_filter :load_activities, only: [:show, :cus_month_calendars,:view_day]
  before_filter :load_book, only: [:booked]

  def index
    @promotions = Promotion.filter(params_query).page(params[:page]).order(discount_percent: :desc, discount_price: :desc, created_at: :asc)
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


  private
  def params_query
    params["criteria"].nil? ? {} : JSON.parse(params["criteria"])
  end
end