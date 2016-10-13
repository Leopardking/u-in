class Image < ActiveRecord::Base
  ##
  # Paperclip
  has_attached_file :image,
    styles: {
      original:"",
      medium: {processors: [:cropper], geometry: ""}
    },
    default_url: "/assets/default_image.png"
  has_attached_file :avatar,
    styles: {
      original:"",
      medium: {processors: [:cropper], geometry: ""}
    },
    default_url: "/assets/default_image.png"
  ##
  # Relationships
  belongs_to :imageable, polymorphic: true
  belongs_to :user

  ##
  #Validation
  validates_attachment_content_type :image, content_type: ["image/jpeg", "image/png", "image/jpg"]
  validates_attachment_content_type :avatar, content_type: ["image/jpeg", "image/jpg", "image/png"]
  validates_attachment_size :image, :less_than=>MAX_SIZE_IMAGE.megabyte
  validates_attachment_size :avatar, :less_than=>MAX_SIZE_IMAGE.megabyte

  # validate :extract_dimensions
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def reprocess_image!
    image.reprocess! if cropping?
  end

  def reprocess_avatar!
    avatar.reprocess! if cropping?
  end

  def get_dimensions
    if Rails.env.production?
      geometry = Paperclip::Geometry.from_file(self.image.url)
      [geometry.width.to_i, geometry.height.to_i]
    else
      tempfile = File.new "#{Rails.root}/public/#{image.url}"

      unless tempfile.nil?
        geometry = Paperclip::Geometry.from_file(tempfile)
        [geometry.width.to_i, geometry.height.to_i]
      end
    end 
  end

  def ratio
    dimensions = get_dimensions
    return 1 unless dimensions
    dimensions[0] / dimensions[1].to_f
  end

  private
    def extract_dimensions
      return unless errors.blank?
      required_width = MIN_WIDTH_IMAGE
      required_height = MIN_HEIGHT_IMAGE
      tempfile = image.queued_for_write[:original]
      unless tempfile.nil?
        geometry = Paperclip::Geometry.from_file(tempfile)
        errors.add(:image, I18n.t("promotions.validation.width_small", :required_width => required_width)) unless geometry.width.to_i >required_width
        errors.add(:image, I18n.t("promotions.validation.height_small", :required_height => required_height)) unless geometry.height.to_i > required_height
        errors.add(:avatar, I18n.t("promotions.validation.width_small", :required_width => required_width)) unless geometry.width.to_i >required_width
        errors.add(:avatar, I18n.t("promotions.validation.height_small", :required_height => required_height)) unless geometry.height.to_i > required_height
      end
    end
end
