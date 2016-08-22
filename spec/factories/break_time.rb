# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :break_time, :class => 'BreakTimes' do
    break_time Time.now
    break_duration get_time
  end
end

def get_time
    times = [15, 30, 45, 60, 120, 240, 350, 480, 600, 720, 1440]
    times.sample
end
