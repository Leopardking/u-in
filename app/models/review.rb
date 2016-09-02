class Review < ActiveRecord::Base
	belongs_to :user
	belongs_to :promotion
	letsrate_rateable "rating"
end
