namespace :update_data_price do
  task update_value_paid_price: :environment do
    Promotion.all.each do |promo|
      promo.saving_price = promo.price - promo.discount_price
      promo.save
    end
    Booking.all.each do |book|
      @promotion = Promotion.find(book.promotion_id)
      book.promotion_price = @promotion.price
      book.paid_price  = @promotion.saving_price
      book.save
    end
  end
end
