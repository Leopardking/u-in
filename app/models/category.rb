class Category < ActiveRecord::Base
  has_and_belongs_to_many :promotions
  has_and_belongs_to_many :temp_promotions
  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: true
  validates_length_of :name, maximum: 255
end
