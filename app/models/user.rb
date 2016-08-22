class User < ActiveRecord::Base

  TEMP_EMAIL_REGEX = /change@me.com/
  USER_TYPE = {
    merchant: "merchant",
    client: "client",
    admin: "admin"
  }

  attr_accessor :agree_with_tos, :type_sign_up, :search_email

  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :async
  ##
  # Relationships
  has_one :merchant_detail, dependent: :destroy
  has_one :billing_detail, dependent: :destroy
  # belongs_to :billing_detail, dependent: :destroy
  has_many :identitys, dependent: :destroy
  has_many :promotions, dependent: :destroy
  has_many :temp_promotions, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :categories
  has_many :history_v_moneys
  has_many :images
  ##
  # Nested models
  accepts_nested_attributes_for :merchant_detail, :billing_detail

  ##
  # Validates
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, uniqueness: true, on: :create
  validates :agree_with_tos, acceptance: true
  validates :email, presence: true
  delegate :can?, :cannot?, to: :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth.provider, auth.uid)
    user = identity.user ? identity.user : signed_in_resource
    user
  end

  ##
  # Check if user is admin
  def admin?
    self.admin
  end

  ##
  # Check if user is merchant
  def merchant?
    !self.admin? && self.user_type == USER_TYPE[:merchant]
  end

  ##
  # Check if user is client
  def client?
    self.user_type == USER_TYPE[:client]
  end

  def business_account?
    !Merchant.find(id).account_types.map(&:merchant_type).include? "I am an individual"
  end

end
