# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :merchant_detail, :class => 'MerchantDetails' do
    business_name Faker::Name.name
    street_address Faker::Address.street_address
    city Faker::Address.city
    state Faker::Address.state
    zipcode Faker::Address.zip_code
    phone_number Faker::PhoneNumber.phone_number
    lat Faker::Number.number(3)
    lng Faker::Number.number(3)
  end
end
