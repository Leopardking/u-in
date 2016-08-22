class PromotionsController < ApplicationController
  load_and_authorize_resource except: [:new, :create, :share, :get_current_rank, :upload_image, :update, :show, :set_cancel_reactive_status, :publish_promotion]
  skip_authorize_resource only: :show
  skip_before_action :authenticate_user!, only: :show
  layout "promotions_layout"

  ##
  # GET /promotions
  def index
    @agendaView = params[:agendaView].nil? ? "month" : params[:agendaView]
    @default_date = params[:default_date].nil? ? Date.today.to_s : params[:default_date]
    # get only one active promotion
    @promotion = current_user.promotions.includes(:booking_detail,:user).running_promotions(false).first
    if @promotion.blank?
      flash.now[:alert] = t("promotions.list_promotions.no_record")
    end
    render :show
  end


  def new
    @promotion_params = {}
    @promotion_step = nil
    @promotion = Promotion.new
    @promotion.current_step = @promotion_step.nil? ? @promotion.steps.first : @promotion_step
    @promotion.current_step = @promotion.steps.first
    @promotion_step = @promotion.current_step
  end

  def create
    @promotion_params = eval(params[:promotion_params])
    @promotion_step = params[:promotion_step]
    @promotion_params.deep_merge!(params[:promotion]) if params[:promotion].present?
    @promotion = Promotion.new(@promotion_params)
    @promotion.build_booking_detail(@promotion_params["booking_detail_attributes"]) if @promotion_params["booking_detail_attributes"]
    @promotion.current_step = @promotion_step
    if params[:back_button].present?
      @promotion.previous_step
      @promotion_step = @promotion.current_step
    else
      if @promotion.valid?
        if @promotion.last_step?
          unless params["days"].empty?
            @promotion.days_of_week = params["days"].split(",")
          else
            @promotion.days_of_week = params[:promotion]["days_of_week"].split(",") unless params[:promotion]["days_of_week"].empty?
          end
          @promotion.save
          @promotion.categories = Category.where(id: @promotion_params["category_ids"])
          @promotion.images = Image.where(id: @promotion_params["image_ids"].reject(&:blank?).map(&:to_i)) if @promotion_params["image_ids"].present?
          img = @promotion.images.where(image_default: true).order("updated_at").last
          if img
            img.image_default = true
            img.save
          end
        else
          @promotion.build_booking_detail if @promotion.current_step == @promotion.steps.fifth
          @promotion.next_step
        end
        @promotion_step = @promotion.current_step
      else
        @promotion.next_step
        @promotion_step = @promotion.current_step
      end
    end
    # For image form
    @image = Image.new if @promotion.current_step == @promotion.steps.third
    if @promotion.new_record?
      render "new"
    else
      @promotion_step = @promotion_params = nil
      flash[:notice] = "promotion saved!"
      session.delete(:image_default)
      redirect_to promotion_path(@promotion, inactive: true)
    end
  end

  def edit
    authorize! :manage, Promotion
    @promotion = Promotion.find(params[:id])
    @promotion = @promotion.temp_promotion
    @promotion_params = {}
    @promotion_step = nil
    if params[:promotion_step].present?
      @promotion.current_step = params[:promotion_step]
    else
      @promotion.current_step = @promotion.steps.first
    end
    @promotion_step = @promotion.current_step
    session[:current_rank] = nil

    # @promotion.current_step = @promotion_step.nil? ? @promotion.steps.first : @promotion_step
  end

  def update
    authorize! :manage, Promotion
    @promotion = TempPromotion.find(params[:id]).reload
    @promotion_params = eval(params[:promotion_params])
    @promotion_step = params[:promotion_step]
    @promotion_params.deep_merge!(params[:promotion]) if params[:promotion].present?
    @promotion.booking_detail.assign_attributes(@promotion_params["booking_detail_attributes"]) if @promotion_params["booking_detail_attributes"]
    params[:promotion]["days_of_week"] = @promotion.days_of_week if params[:promotion]["days_of_week"].blank?
    @promotion.assign_attributes(@promotion_params)
    @promotion.current_step = @promotion_step
    if params[:skip_to].present?
      @promotion_step = params[:skip_to]
      @promotion.current_step = params[:skip_to]
      render "edit"
    else
      not_updated = true
      if @promotion.last_step? || params[:promotion]["days_of_week"]
        if params["days"].present?
          @promotion.days_of_week = params["days"].split(",")
        else
          @promotion.days_of_week = params[:promotion]["days_of_week"].split(",").flatten
        end
      end
      if @promotion.save
        not_updated = false
        @promotion.categories = Category.where(id: @promotion_params["category_ids"]) if @promotion_params["category_ids"].present?
        @promotion.images = Image.where(id: @promotion_params["image_ids"].reject(&:blank?).map(&:to_i)) if @promotion_params["image_ids"].present?
        img = @promotion.images.where(image_default: true).order("updated_at").last
        if img
          img.image_default = true
          img.save
        end
      end
      @promotion_step = @promotion.current_step
      # For image form
      @image = Image.new if @promotion.current_step == @promotion.steps.third
      if not_updated
        render "edit"
      else
        @promotion_step = @promotion_params = nil
        flash[:notice] = "promotion updated!"
        if @promotion.cancel_status
          redirect_to promotion_path(@promotion.promotion, inactive: true, updated: true)
        else
          redirect_to promotion_path(@promotion.promotion, updated: true)
        end
      end
    end
  end

  def show
    @promotion = Promotion.find params[:id]
    @promotion = @promotion.temp_promotion if params[:updated] && current_user
    @agendaView = params[:agendaView].nil? ? "month" : params[:agendaView]
    @default_date = params[:default_date].nil? ? Date.today.to_s : params[:default_date]

  end

  def show_inactive
    @agendaView = params[:agendaView].nil? ? "month" : params[:agendaView]
    @default_date = params[:default_date].nil? ? Date.today.to_s : params[:default_date]
    @promotions = current_user.promotions.includes(:booking_detail,:user).order(cancel_status: :asc)
    if @promotions.blank?
      #retain the previously added alert message if any
      flash.now[:alert] ||= []
      flash.now[:alert] << t("promotions.list_promotions.no_record")
      flash.now[:alert] = flash.now[:alert].join("<br>").html_safe #show the alert messages one by one
    end
  end

  # ##
  # # GET
  def share
    @promotion = Promotion.find(params[:id])
  end

  def add_image
    @image = Image.new
    @image_name = params[:image_name]
    @img_id = params[:img_id]
    @action = params[:activity]
    @promotion_id = params[:promotion_id]
  end

  def upload_image
    @value_default = params[:image][:image_default]
    if  params[:img_id].present?
      @image = Image.find params[:img_id]
      # if current user doesn't images for promotion
      unless current_user.images.empty?
        image_service.update_default_image(current_user, @value_default, @image)
      end
      unless params[:image][:crop_x].present?
        # No change file, only change image default
        image_service.update_all_images_of_promotion(current_user.id, params[:image][:promotion_id])
        @image.update_attributes(image_default: params[:image][:image_default])
      else
        # Have change new image, update
        @image.update_attributes(image_params)
        if @image.errors.empty?
          @image.reprocess_image!
          flash[:notice]= t("promotions.image_upload_complete.upload_success")
        end
      end
    end
    unless @image.errors.empty?
      render 'image_upload_fail.js.erb'
    end
  end

  def get_current_rank
    current_rank = nil
    session[:total_rank] = nil
    session[:current_rank] = nil
    current_rank = Promotion.get_current_rank(params.permit(:id,:discount_percent, :discount, category_ids: []))
    session[:total_rank] = current_rank[:size]
    session[:current_rank] = current_rank[:current_rank]
    render json:{
      current_rank: current_rank[:current_rank],
      total_rank: current_rank[:total_ranks]
    }
  end

  def set_cancel_reactive_status
    authorize! :manage, Promotion
    promotion = Promotion.find_by_id(params[:id])
    if promotion.update_attribute(:cancel_status, !promotion.cancel_status)
      current_user.promotions.running_promotions(false).where().not(id: promotion.id).each{|promo| promo.update_attribute(:cancel_status, true)} if !promotion.cancel_status
      promotion.update_attribute(:active_times, promotion.active_times + 1)
      flash[:notice]= "Updated promotion successfully"
    else
      flash[:alert] = "Can't update the promotion"
    end
    redirect_to promotions_path
  end

  def publish_promotion
    promotion = TempPromotion.find_by_id(params[:id])
    publish = promotion_service.publish_promotion promotion
    redirect_to promotions_path
  end

  def reset_pricing
    authorize! :manage, Promotion
    @promotion = Promotion.find(params[:id])
    @promotion.current_step = @promotion.steps.fifth
  end

  def update_pricing
    authorize! :manage, Promotion
    @promotion = Promotion.find(params[:id])
    if @promotion.update_attributes(pricing_params)
      redirect_to promotions_path, notice: "Successfully updated the promotion"
    else
      render :reset_pricing
    end
  end

  def check_deletion
    authorize! :manage, Promotion
    @promotion = Promotion.find(params[:id])
    # TODO: To check the outstanding bookings once the booking functionality is implemented
    @has_bookings = @promotion.active?
    respond_to do |format|
     format.js
   end
  end

  def destroy
    authorize! :manage, Promotion
    promotion = Promotion.find(params[:id])
    if promotion.destroy
      flash[:notice]= t("promotions.destroy.destroy_successfull")
    else
      flash[:alert] = "Can't delete the promotion"
    end
    redirect_to show_inactive_promotions_path
  end

  def apply_blackout
    authorize! :manage, Promotion
    promotion = Promotion.find(params[:id])
    #TODO: CHck for any bookings before applying
    @blackout = promotion.other_blackouts.new(blackout_from: params[:blackout_from], blackout_to: params[:blackout_to])
    @blackout.blackout_from = Time.zone.parse("#{params[:selected_date]} #{params[:blackout_from]}")
    @blackout.blackout_to = Time.zone.parse("#{params[:selected_date]} #{params[:blackout_to]}")
    # To restore the calendar view
    @agendaView = params[:agendaView]
    @blackout.save
    respond_to do |format|
      format.js
    end
  end

  def get_blackout_details
    authorize! :manage, Promotion
    @blackout = OtherBlackout.includes(:promotion).find(params[:blackout_id])
  end

  def cancel_blackout
    authorize! :manage, Promotion
    blackout = OtherBlackout.find(params[:blackout_id])
    @result = blackout.destroy
    respond_to do |format|
      format.js { render :get_blackout_details }
    end
  end

  private

  def promotion_service
    @promotion_service ||= PromotionService.new current_user
  end

  def image_service
      @image_service ||= ImageService.new
  end

  def image_params
    params.require(:image).permit(:image, :image_no, :description_image, :image_default, :crop_x, :crop_y, :crop_w, :crop_h, :user_id, :img_id, :promotion_id, :imageable_id)
  end

  def pricing_params
    params.require(:promotion).permit(:price, :discount_percent, :discount_price,  :cancellation_fee, :cancellation_minimum, :saving_price)
  end
end
