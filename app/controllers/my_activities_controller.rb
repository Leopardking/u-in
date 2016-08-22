class MyActivitiesController < ApplicationController
  ##
  # GET
  def index
    authorize! :book, Booking
    if params[:promotion_name].present?
      promotions = Promotion.where("LOWER(name) like ?", "%#{params[:promotion_name].downcase}%")
      if !current_user.admin
      @booked = current_user.bookings.where(status: true, promotion_id: promotions.ids).order("id DESC").page(params[:page])
      else
        @booked = Booking.where(status: true, promotion_id: promotions.ids).order("id DESC").page(params[:page])
      end
    else
      if !current_user.admin
      @booked = current_user.bookings.where("status=TRUE").order("id DESC").page(params[:page])
      else
        @booked = Booking.where("status=TRUE").order("id DESC").page(params[:page])
      end
    end
  end
  # GET /promotions/contact
  def contact
    authorize! :contact, User
    @detail = Promotion.select("user_id").find_by_id(params[:id]).user.merchant_detail
  end
  ##
  # POST /my_activities/contact
  def send_contact
    data = {}
    data[:email] = params[:contact][:email]
    data[:message] = params[:contact][:message]

    respond_to do |format|
      if UserMailer.delay.send_merchant_contact(data)
        format.js
      else
        format.html {render "contact"}
      end
    end
  end
  ##
  #GET
  def destroy
    @booked = Booking.find_by_id(params[:id])
    promotion = Promotion.select("user_id,price,discount_percent,discount_price,cancellation_fee").find_by_id(@booked.promotion_id)
    @deposit = promotion.discount_price - promotion.cancellation_fee
    @bussiness_name = promotion.user.merchant_detail.business_name
  end
  def cancel_booking
    if current_user.admin
      #refund real money
      billing = BillingDetail.where("user_id = ? AND always_use = TRUE", params_history[:user_id]).last
      deposit = update_create_v_money
      booked = Booking.find_by_id(params_history[:booking_id])
      begin
        ch = Stripe::Charge.retrieve(booked.charge_id)
        refund = ch.refunds.create(:amount => (deposit*100).to_i)
        HistoryVMoney.create(params_history.merge(amount: deposit))
      rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to :back
      end
      flash[:notice] = t("my_activities.cancel_promotion_confirm.deposit_msg", deposit: deposit)
      redirect_to my_activities_path
    else
      deposit = update_create_v_money
      user = User.find_by_id(params_history[:user_id])
      vitrual_money = user.virtual_money + deposit
      user.update(virtual_money: vitrual_money)
      HistoryVMoney.create(params_history.merge(amount: deposit))
      flash[:notice] = t("my_activities.cancel_promotion_confirm.deposit_msg", deposit: deposit)
      redirect_to my_activities_path
    end
  end
  def update_create_v_money
      booked = Booking.find_by_id(params_history[:booking_id])
      booked.status = false
      booked.save
      promotion = Promotion.select("user_id,price,discount_percent,discount_price,cancellation_fee").find_by_id(booked.promotion_id)
      deposit = promotion.discount_price - promotion.cancellation_fee
      return deposit
  end
  def params_history
    if current_user.admin
      params[:history_v_money][:action] = 1
    else
      params[:history_v_money][:action] = 0
    end
    params.require(:history_v_money).permit(:user_id, :promotion_id, :booking_id, :action)
  end
end
