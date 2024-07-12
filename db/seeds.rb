# frozen_string_literal: true

require 'faker'

original_links = [
  'https://code.likeagirl.io/why-disagreement-in-the-workplace-is-key-to-outperformance-163288dd559b',
  'https://medium.com/@kmorpex/10-advanced-c-tricks-for-experienced-developers-26a48c6a8c9c',
  'https://productcoalition.com/no-more-mayhem-how-we-solved-our-meeting-overload-problem-8005c83bd0d2',
  'https://blog.chatbotslife.com/dialogflow-tutorial-build-resume-chatbot-for-google-assistant-part-1-12c8c5e78c10',
  'https://medium.com/nerd-for-tech/is-space-based-pattern-only-for-cloud-based-hosted-5a633eb74c2',
  'https://medium.com/opendoor-labs/deep-dive-testing-a-microservice-architecture-with-qa-environments-cd338648c37b',
  'https://iorilan.medium.com/a-basic-question-in-security-interview-how-do-you-store-passwords-in-the-database-676c125cff64',
  'https://medium.com/dare-to-be-better/4-alternatives-to-postman-to-consider-after-their-latest-update-f9de86ce2afe',
  'https://medium.com/bytebytego-system-design-alliance/system-design-blueprint-the-ultimate-guide-e27b914bf8f1',
  'https://brianjenney.medium.com/how-you-can-start-a-5-figure-side-business-as-software-engineer-15b5634f3821',
  'https://derekcardwell.medium.com/im-unemployed-for-over-two-years-as-a-software-engineer-bd1ad6f95a54',
  'https://cj-hewett.medium.com/node-js-is-faster-than-go-5c2c72017829',
  'https://levelup.gitconnected.com/the-resume-that-got-a-software-engineer-a-300-000-job-at-google-8c5a1ecff40f'
]

# List of country codes for geolocation
country_codes = ['MY', 'US', 'IN', 'SG', 'AU', 'GB']

# Create links and visits
original_links.each do |original_url|
  service = LinkShortenerService.new(original_url)
  link = service.build_short_url
  link.save!

  rand(1..30).times do
    link.visits.create(
      timestamp: Faker::Time.between(from: 7.days.ago, to: Time.now),
      geolocation: {
        ip: Faker::Internet.ip_v4_address,
        country: country_codes.sample
      }
    )
  end
end
