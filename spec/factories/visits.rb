FactoryBot.define do
  factory :visit do
    association :link
    geolocation do
      { ip: Faker::Internet.ip_v4_address, country: Faker::Address.country_code }.to_json
    end
    timestamp { Time.zone.now }
  end
end
