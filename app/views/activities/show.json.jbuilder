json.promotion @activity

json.booking_detail do
  json.id @activity.booking_detail.id
  json.booking_criterion @activity.booking_detail.booking_criterion
  json.booking_start_time @activity.booking_detail.booking_start_time
  json.booking_end_time @activity.booking_detail.booking_end_time
  json.blackout_from @activity.booking_detail.blackout_from
  json.blackout_to @activity.booking_detail.blackout_to
  json.booking_duration @activity.booking_detail.booking_duration
  json.bookings_per_duration @activity.booking_detail.bookings_per_duration
  arr_per_duration = []
  @activity.booking_detail.bookings_per_duration.times {|n| arr_per_duration << n+1}
  json.bookings_per_duration_arr arr_per_duration
  json.created_at @activity.booking_detail.created_at
  json.updated_at @activity.booking_detail.updated_at
  json.maximum_bookings @activity.booking_detail.maximum_bookings
  arr_max_booking = []
  @activity.booking_detail.maximum_bookings.times {|n| arr_max_booking << n+1}
  json.maximum_bookings_arr arr_max_booking 
  json.booking_detailable_id @activity.booking_detail.booking_detailable_id
  json.booking_detailable_type @activity.booking_detail.booking_detailable_type
end
json.images @activity.images.map { |v| v.image.url}
json.image @activity.images.first.image.url(:medium) rescue 0
if @activity.end_date.present?
  json.space PromotionService.new.show_space(@activity, @activity.start_date, @activity.end_date, @activity.id, nil)
else
  json.space "25+"
end
json.is_login user_signed_in? ? true : false
json.user_id user_signed_in? ? current_user.id : false

json.reviews @activity.reviews do |review|
  json.review_id review.id
  json.user_id review.user_id
  json.promotion_id review.promotion_id
  json.content review.content
  json.rating review.rating
  json.created_at review.created_at
  json.updated_at review.updated_at
  json.user do
    json.user_name review.user.name rescue nil
    json.user_id review.user.id rescue nil
  end
end