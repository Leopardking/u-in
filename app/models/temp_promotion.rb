class TempPromotion < ActiveRecord::Base
  include Publish
  belongs_to :promotion

end