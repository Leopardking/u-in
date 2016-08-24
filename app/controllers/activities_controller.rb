class ActivitiesController < ApplicationController
  before_filter :load_activities, only: [:show, :cus_month_calendars,:view_day]
  before_filter :load_book, only: [:booked]

  def index
    @promotions = Promotion.filter(params).page(params[:page])
  end
end
