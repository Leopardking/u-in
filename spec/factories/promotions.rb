# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :promotion do
    #Define factory for User model
    name "#{Devise.friendly_token.first(20)}"
    description "#{Devise.friendly_token.first(10)} #{Devise.friendly_token.first(15)}  #{Devise.friendly_token.first(20)}"
    google_map_link ""
    street_address_1 "#{Devise.friendly_token.first(10)} #{Devise.friendly_token.first(10)}"
    street_address_2 "#{Devise.friendly_token.first(11)} #{Devise.friendly_token.first(15)}"
    city "#{Devise.friendly_token.first(3)} #{Devise.friendly_token.first(5)} #{Devise.friendly_token.first(6)}"
    state "#{Devise.friendly_token.first(4)} #{Devise.friendly_token.first(3)} #{Devise.friendly_token.first(6)}"
    zipcode "70000"
    phone_number "8888888888"
    youtube_video ""
    price 200.5
    discount_percent 10
    discount_price 180
    start_date "#{Time.now.to_s(:db)}"
    end_date "#{(Time.now+36000).to_s(:db)}"
    repeat false
    booking_available 200
    cancellation_minimum 2
    cancellation_fee 5
    working_schedule nil
  end
end
