# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :faq do
    question { Faker::Lorem.paragraph }
    answer { Faker::Lorem.paragraph }
  end
end