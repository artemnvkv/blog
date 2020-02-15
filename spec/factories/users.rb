FactoryBot.define do
  factory :user do
    login { Faker::Internet.unique.user_name }
  end
end
