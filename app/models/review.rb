class Review < ActiveRecord::Base
	belongs_to :user
	belongs_to :promotion
	validates :content, presence: true
	after_create :create_ratyrate
	ratyrate_rateable "rating"

	# for more doc you can see: https://github.com/wazery/ratyrate/blob/master/lib/ratyrate/model.rb#L5
	def create_ratyrate
		self.rate(self.rating, self.user, "rating", false)
	end
end
