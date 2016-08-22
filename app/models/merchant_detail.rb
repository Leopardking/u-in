class MerchantDetail < ActiveRecord::Base

  ##
  # Relationships
  belongs_to :user


  ##
  validates :business_name, presence: { message: I18n.t("activerecord.models.merchant_detail.business_name.precense") }
  validates :street_address, presence: { message: I18n.t("activerecord.models.merchant_detail.street_address.precense") }
  validates :city, presence: { message: I18n.t("activerecord.models.merchant_detail.city.precense") }
  validates :zipcode, presence: { message: I18n.t("activerecord.models.merchant_detail.zipcode.precense") }
  validates :zipcode, numericality: { message: I18n.t("activerecord.models.merchant_detail.zipcode.numericality") }

end
