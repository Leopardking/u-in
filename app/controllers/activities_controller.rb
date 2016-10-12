class ActivitiesController < ApplicationController
  before_filter :load_activities, only: [:show, :cus_month_calendars,:view_day]
  before_filter :load_book, only: [:booked]
  skip_before_action :authenticate_user!
  skip_before_action :load_activities, only: [:show]
  before_filter :load_current_user
  before_filter :find_promotion, only: [:show, :bookmark, :remove_bookmark, :remove_past_life]

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
  end

  def my_activity
    bookings      = current_user.bookings
    date_now      = Time.now.strftime("%Y-%m-%d %H:%M")
    @upcomings    = bookings.where('book_date > ?', date_now).group(:promotion_id)
    # need validate with past time
    @bookmark     = current_user.bookmarks
    @myPastLife   = bookings.where('book_date <= ? AND listing_show= ?', date_now, true).group(:promotion_id)
  end

  def bookmark
    if current_user.present?
      @bookmark = @activity.bookmarks.build(user_id: current_user.id)
      render json: @bookmark, status: 200 if @bookmark.save
    else
      render json: @bookmark, status: :unprocessable_entity
    end
  end

  def remove_bookmark
    remove_bookmark = @activity.bookmarks.last.delete
    @bookmark = current_user.bookmarks
    if remove_bookmark.delete
      render json: @bookmark, status: 200
    else
      render json: @bookmark, status: :unprocessable_entity
    end
  end

  def remove_past_life
    promotion_id    = params[:id]
    bookings        = current_user.bookings.where("promotion_id LIKE ?", promotion_id).update_all(listing_show: false)
    date_now        = Time.now.strftime("%Y-%m-%d %H:%M")
    @myPastLife     = current_user.bookings.where('book_date <= ? AND listing_show = ?', date_now, true).group(:promotion_id)
    
    render json: @myPastLife, status: 200
  end

  def build_information_user
    @info = current_user.create_billing_detail(params_info)
    if @info.save
      render json: @info, status: 200
    else
      render json: [], status: :unprocessable_entity
    end
  end

  def load_image
    @images = Review.find(params[:review_id]).images
    respond_to do |format|
       format.json
    end    
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

  def find_promotion
    @activity = Promotion.find(params[:id])
  end

  def params_info
    # get last 4 number cc
    params[:ccard_last4] = params[:ccard_last4].split(//).last(4).join
   
    params.permit(:card_type, :ccard_last4, :stripe_profile_token, :first_name, :last_name, :street_address, :city, :zipcode, :state, :always_use, :user_id, :customer_id, :same_as_company_address, :street_address_2, :email, :phone, :name_card, :exp_month, :exp_year, :security_code)
  end
end