class AccountType < ActiveRecord::Base
	has_many :merchant_account_types
	has_many :merchants, through: :merchant_account_types
end
