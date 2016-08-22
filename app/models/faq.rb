class Faq < ActiveRecord::Base
  paginates_per 10
  ##
  # Validate
  validates :question, presence: true
  validates :answer, presence: true

  def self.search(search_text=nil)
	return Faq.where("question LIKE ? OR answer LIKE ?", "%#{search_text}%", "%#{search_text}%")	
  end
end
