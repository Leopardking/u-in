json.promotion @activity
json.images @activity.images.map { |v| v.image.url}
json.image @activity.images.first.image.url(:medium) rescue 0
if @activity.end_date.present?
  json.space PromotionService.new.show_space(@activity, @activity.start_date, @activity.end_date, @activity.id, nil)
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