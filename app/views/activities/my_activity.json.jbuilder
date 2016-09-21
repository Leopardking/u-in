json.upcoming do
	json.booking do
	  json.id @upcomings.id
	  json.user_id @upcomings.user_id
	  json.promotion_id @upcomings.promotion_id
	  json.start_time @upcomings.start_time
	  json.end_time @upcomings.end_time
	end

	json.promotion do
	  json.id @upcomings.promotion.id
	  json.name @upcomings.promotion.name
	  json.discount_percent @upcomings.promotion.discount_percent
	  json.discount_price @upcomings.promotion.discount_price
	  json.image @upcomings.promotion.images.first.image.url(:medium)
	end
end