FactoryBot.define do
  factory :post do
    user nil
    title { Faker::Lorem.characters(10) }
    body { Faker::Lorem.sentence(10) }
    ip_address { Faker::Internet.unique.public_ip_v4_address }
  end
end
