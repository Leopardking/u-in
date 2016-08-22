# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :billing_detail, :class => 'BillingDetails' do
    card_type "visa"
    ccard_last4 "4242"
    stripe_profile_token "tok_104HJ4409U0Vwg0adT5reAGo"
    first_name "An"
    last_name "Vo"
    street_address "10 Pho Quang"
    city "HCMC"
    zipcode "70000"
    state "HCM"
    always_use ""
  end
end
