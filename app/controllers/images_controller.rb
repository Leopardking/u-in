class ImagesController < ApplicationController
  load_and_authorize_resource except: [:upload_image,:upload_image_step3, :upload_image_from_angular]

  def upload_image_common params
    reassign_params if params[:fromAngular].eql? "true"
    @image = image_service.create_or_update_image(params[:image_id], image_upoloads_params)
    unless @image.errors.empty?
      render "upload_image_fail.js.erb"
    end
  end

  def upload_image_from_angular params
    reassign_params if params[:fromAngular].eql? "true"
    @image = image_service.create_or_update_image(params[:image_id], image_upoloads_params)
  end

  def upload_image
    upload_image_common params
  end

  def upload_image_step3
    upload_image_common params
  end

  private
    def image_upoloads_params
      params.required(:image).permit(:image, :avatar, :image_no, :description_image, :image_default, :crop_x, :crop_y, :crop_w, :crop_h, :user_id, :img_id, :using_image)
    end

    def image_service
      @image ||= ImageService.new()
    end

    def reassign_params
      params[:image][:using_image] = "booking"
      params[:image][:user_id] = current_user.id
      params[:image][:image_id] = nil
    end
end
