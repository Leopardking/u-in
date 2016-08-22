class BillingDetail < ActiveRecord::Base

  ##
  # Attribute Accessor
  attr_accessor :email_confirmation

  ##
  # Relationships
  belongs_to :user


  ##
  # Validation
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :card_type, presence: true
  validates :ccard_last4, presence: true, numericality: { only_integer: true }
  validates :street_address, presence: true
  validates :city, presence: true
  validates :zipcode, presence: true
  validate :zipcode, format: {:with => /^\d{1,9}?([-\s])?(\d{1,9})?$/}
  validates :state, presence: true
  validates :phone, presence: true, numericality: {only_integer: true}
  validate :phone, :format => {:with => /^((\+)?[1-9]{1,12})?([-\s\.])?((\(\d{1,12}\))|\d{1,12})(([-\s\.])?[0-9]{1,12}){1,12}$/}
  validates :email, presence: true
  validate :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates :name_card, presence: true
  validates :security_code, presence: true
  SUPPORTED_CARDS = [
    ['Visa', 'visa'],
    ['MasterCard', 'master'],
    ['American Express', 'american_express']
  ]
  LAST_NUMBER_CARD = 4
end
