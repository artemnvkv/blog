FactoryBot.define do
  factory :connection do
    user nil
    ip_address { Faker::Internet.unique.public_ip_v4_address }
  end
end
