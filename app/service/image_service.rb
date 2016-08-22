class ImageService < BaseService

  # Update value for field image_default
  def update_default_image current_user, val_default, image
    if val_default == VALUE_DEFAULT
      if image.imageable.nil?
        @image = get_image(current_user.id, nil)
        unless @image.nil?
          @image.image_default = false
          @image.save
        end
      else
        get_image(current_user.id, image.imageable.id)
      end
    end
  end

  def get_image id, promotion_id
    Image.where(user_id: id,image_default: true,imageable_id: promotion_id).first
  end

  def update_all_images_of_promotion id, promotion_id
    @images = Image.where(user_id: id,image_default: true, imageable_id: promotion_id)
    @images.update_all(image_default: false)
  end

  def update_crop_avatar image_params, image_id
    @image = Image.find image_id
    if @image.present?
      @image.update_attributes(image_params)
    end
    @image
  end

  def update_user_id_for_avatar user, avatar_id
    @avatar = Image.find_by_id avatar_id
    if @avatar && @avatar.user_id.nil?
      @avatar.user_id = user.id
    end
  end

  def create_or_update_image image_id, image_params
    if image_id.present?
      # If user had avatar, so update avatar
      @image = Image.find image_id
      @image.update_attributes( image_params)
      @image
    else
      # If user didn't had avatar -> create avatar new
      @image = Image.create(image_params)
    end
  end
end
