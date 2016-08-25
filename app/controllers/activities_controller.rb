class ActivitiesController < ApplicationController
  before_filter :load_activities, only: [:show, :cus_month_calendars,:view_day]
  before_filter :load_book, only: [:booked]

  def index
    @promotions = Promotion.filter(params).page(params[:page])
    @data 			= MerchantDetail.all.limit(10)
    @state 			= MerchantDetail.limit(50).pluck(:state)
		respond_to do |format|
		  format.html # show.html.erb
		  format.xml  { render :xml => @data }
		  format.json { render :json => { 
		  	:data => @data,
		  	:state => @state 
		  	}
		  }
		end
  end
end
