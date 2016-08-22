# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :segment do
    promotion_id 1
    start_time "2016-04-12 16:36:41"
    end_time "2016-04-12 16:36:41"
    bookings_count 1
    is_blackout false
    max_bookings 1
  end
end
