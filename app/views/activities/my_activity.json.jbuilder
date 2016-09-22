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

	json.toScreen @upcomings.promotion.images.map {|v| v.image.url}
end

json.pastlife do
	
end

# if want to multi upcoming
#json.set! "upcoming" do
#  json.booking @upcomings do |upcoming|
#	  json.id upcoming.id
#	  json.user_id upcoming.user_id
#	  json.promotion_id upcoming.promotion_id
#	  json.start_time upcoming.start_time
#		json.time upcoming.strftime("%B %d, %H:%M%P")
#	  json.end_time upcoming.end_time
#		json.set! "promotion" do
#		  json.id upcoming.promotion.id
#		  json.name upcoming.promotion.name
#		  json.discount_percent upcoming.promotion.discount_percent
#		  json.discount_price upcoming.promotion.discount_price
#		  json.image upcoming.promotion.images.first.image.url(:medium) rescue "0"
#		end
#	end
#end