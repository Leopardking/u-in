namespace :update_number_book_free do
  task book_free_merchant: :environment do
    User.all.each do |user|
      if user.user_type == User::USER_TYPE[:merchant]
        user.booking_free = 0
        user.save
      end
    end
  end

  task update_value_default: :environment do
    MerchantDetail.all.each do |merchant|
      merchant.booking_free = 0
      merchant.save
    end
  end
end
