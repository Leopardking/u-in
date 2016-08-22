namespace :update_image_default do
  task image_default_promotion: :environment do
    Promotion.all.each do |p|
      @images = p.images
      @images.each do |m|
        m.image_default = false
        m.save
      end
      @image = p.images.first
      @image.image_default = true
      @image.save
    end
  end

  task remove_image_no_promotion: :environment do
    Image.all.each do |image|
      if image.promotion_id == nil
        image.destroy
      end
    end
  end
end

