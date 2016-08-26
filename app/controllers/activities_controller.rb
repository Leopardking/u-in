class ActivitiesController < ApplicationController
  before_filter :load_activities, only: [:show, :cus_month_calendars,:view_day]
  before_filter :load_book, only: [:booked]

  def index
    @promotions = Promotion.filter(params_query).page(params[:page])
    respond_to do |format|
      format.html
      format.json { render :json => @promotions }
    end
  end


  private
  def params_query
    params[:criteria].nil? ? {} : JSON.parse(params[:criteria])
  end
end