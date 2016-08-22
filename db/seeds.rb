# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if User.count == 0
  users = User.create([
    { :password => "98uhbgt54", :email => "test_client_1@uin.com", :confirmed_at => "2014-05-31 09:05:26", :name => "Test Client", :user_type => "client", :admin => false },
    { :password => "98uhbgt54", :email => "test_client_2@uin.com", :confirmed_at => "2014-05-31 09:05:26", :name => "Test Client 2", :user_type => "client", :admin => false },
    { :password => "98uhbgt54", :email => "test_merchant@uin.com", :confirmed_at => "2014-05-31 09:05:26", :name => "Merchant Test", :user_type => "merchant", :admin => false },
    { :password => "98uhbgt54", :email => "test_merchant_001@uin.com", :confirmed_at => "2014-05-31 09:05:26", :name => "Merchant 001 Test", :user_type => "merchant", :admin => false },
    { :password => "98uhbgt54", :email => "admin@uin.com", :confirmed_at => "2014-05-31 09:05:26", :name => "Admin Test", :user_type => "admin", :admin => true }
  ])

  AccountType.create([
    {merchant_type: "I am an individual"},
    {merchant_type: "I am a business with employees"},
    {merchant_type: "I rent equipment"}
  ])

  MerchantAccountType.create([
    {merchant_id: User.find_by_email("test_merchant@uin.com").id, account_type: AccountType.find_by_merchant_type("I am an individual")},
    {merchant_id: User.find_by_email("test_merchant_001@uin.com").id, account_type: AccountType.find_by_merchant_type("I am a business with employees")}
  ])

  User.where(user_type: "merchant").each do |u|
    merchant_detail = u.build_merchant_detail(business_name: Devise.friendly_token.first(20), street_address: Devise.friendly_token.first(35), city: Devise.friendly_token.first(7), state: Devise.friendly_token.first(8), zipcode: '70000', phone_number: '99999900000', user_id: u.id)
    merchant_detail.save
  end
end

##
# Make 100 Category
if Category.count == 0
  for i in 1..100
    Category.create(name: "Category No. #{i}")
  end
end

