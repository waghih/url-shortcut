FactoryBot.define do
  factory :link do
    original_url { Faker::Internet.url }
    short_url { SecureRandom.alphanumeric(6) }
    title { Faker::Lorem.sentence }
    icon_url { "https://www.google.com/s2/favicons?domain=#{URI.parse(original_url).host}&sz=32" }
  end
end
