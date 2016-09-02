json.promotion @activity
json.images @activity.images.map { |v| v.image.url}
json.image @activity.images.first.image.url(:medium)
if @activity.end_date.present?
	json.space PromotionService.new.show_space(@activity, @activity.start_date, @activity.end_date, @activity.id, nil)
end

json.reviews @activity.reviews
json.user_name @activity.reviews.map {|v| v.user.first_name if v.user.present? }