json.set! "upcoming" do
  json.booking @upcomings do |upcoming|
	  json.id upcoming.id
	  json.user_id upcoming.user_id
	  json.promotion_id upcoming.promotion_id
	  json.start_time upcoming.start_time
		json.time upcoming.start_time.strftime("%B %d, %H:%M%P")
	  json.end_time upcoming.end_time
		json.set! "promotion" do
		  json.id upcoming.promotion.id
		  json.name upcoming.promotion.name
		  json.discount_percent upcoming.promotion.discount_percent
		  json.discount_price upcoming.promotion.discount_price
		  json.image upcoming.promotion.images.first.image.url(:medium) rescue json.image "0"
		end
	end
end

# json.toScreen @upcomings.last.promotion.images.map {|v| v.image.url} rescue  "0"
json.toScreen 0

json.set! "bookmark" do
  json.booking @bookmark do |bookmark|
	  json.id bookmark.id
	  json.user_id bookmark.user_id
	  json.promotion_id bookmark.promotion_id
	  json.start_time bookmark.promotion.start_time
		json.time bookmark.promotion.start_date.strftime("%B %d, %Y")
	  json.end_time bookmark.promotion.end_date
		json.set! "promotion" do
		  json.id bookmark.promotion.id
		  json.name bookmark.promotion.name
		  json.discount_percent bookmark.promotion.discount_percent
		  json.discount_price bookmark.promotion.discount_price
		  json.image bookmark.promotion.images.first.image.url(:medium) rescue json.image "0"
		end
	end
end

json.set! "pastLife" do
  json.booking @myPastLife do |booking|
	  json.id booking.id
	  json.user_id booking.user_id
	  json.promotion_id booking.promotion_id
	  json.start_time booking.promotion.start_time
		json.time booking.promotion.start_date.strftime("%B %d, %Y")
	  json.end_time booking.promotion.end_date
		json.set! "promotion" do
		  json.id booking.promotion.id
		  json.name booking.promotion.name
		  json.discount_percent booking.promotion.discount_percent
		  json.discount_price booking.promotion.discount_price
		  json.set! "review" do
		  	json.id booking.promotion.reviews.last.id rescue nil
		  	json.promotion_id booking.promotion.reviews.last.promotion_id rescue nil
		  	json.user_id booking.promotion.reviews.last.user_id rescue nil
		  	json.content booking.promotion.reviews.last.content rescue nil
		  	json.rating booking.promotion.reviews.last.rating rescue nil
	  		if booking.promotion.reviews.try(:last).try(:images) == nil
	  			json.images "0"
	  		else
	  			json.images booking.promotion.reviews.last.images do |image|
	  				json.image image.image.url(:medium)
	  			end
	  		end
		  end
		end
	end
end