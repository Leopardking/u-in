# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name "#{Devise.friendly_token.first(10)}"
  end
end
