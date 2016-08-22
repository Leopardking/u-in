namespace :db do
  task migrate_booking_data_to_booking_detail: :environment do
    Promotion.all.each do |promo|
      promo.build_booking_detail(booking_criterion: promo.booking_criterion, booking_start_time: promo.booking_start_time, booking_end_time: promo.booking_end_time, blackout_from: promo.blackout_from, blackout_to: promo.blackout_to, booking_duration: promo.booking_duration, bookings_per_duration: promo.bookings_per_duration)
      promo.save
    end
  end
end
