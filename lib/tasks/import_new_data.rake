namespace :import_new_data do
  task clone_promotion_to_temp_promotion: :environment do
    Promotion.transaction do
      promotions = Promotion.all
      promotions.each do |promotion|
        promotion.clone_data_to_temp_promotion
      end
    end
  end

end

