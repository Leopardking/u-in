# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :working_schedule do
    start_date Time.now.to_date
    end_date Time.now.to_date
    start_time Time.now
    end_time Time.now
    active [true, false].sample
    segment get_time
    segment_duration get_time
    schedule_name Faker::Lorem.sentence
  end
end

def get_time
    times = [15, 30, 45, 60, 120, 240, 350, 480, 600, 720, 1440]
    times.sample
end
