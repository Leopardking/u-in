class ImagesController < ApplicationController
  load_and_authorize_resource except: [:upload_image,:upload_image_step3, :upload_image_from_angular]

  def upload_image_common params
    @image = image_service.create_or_update_image(params[:image_id], image_upoloads_params)
    unless @image.errors.empty?
      render "upload_image_fail.js.erb"
    end
  end

  def upload_image_from_angular
    reassign_params if params[:fromAngular].eql? "true"
    @image = image_service.create_or_update_image(params[:image_id], image_upoloads_params)
    render json: @image, status: 200

    unless @image.errors.empty?
      render json: @image, status: :unprocessable_entity
    end
  end

  def upload_image
    upload_image_common params
  end

  def upload_image_step3
    upload_image_common params
  end

  private
    def image_upoloads_params
      params.required(:image).permit(:image, :avatar, :image_no, :description_image, :image_default, :crop_x, :crop_y, :crop_w, :crop_h, :user_id, :img_id, :using_image, :imageable_id, :imageable_type)
    end

    def image_service
      @image ||= ImageService.new()
    end

    def reassign_params
      # craete has many belong to many with manual
      params[:image][:using_image] = "review"
      params[:image][:user_id] = current_user.id
      params[:image][:image_id] = nil
      params[:image][:imageable_id] = params[:image][:review_id]
      params[:image][:imageable_type] = "Review"
    end
end
