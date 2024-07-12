require 'rails_helper'

RSpec.describe LinkShortenerService, type: :service do
  let(:original_url) { Faker::Internet.url }
  let(:title) { Faker::Lorem.sentence }
  let(:service) { described_class.new(original_url, title) }

  describe '#initialize' do
    it 'initializes with original_url and title' do
      expect(service.instance_variable_get(:@original_url)).to eq(original_url)
      expect(service.instance_variable_get(:@title)).to eq(title)
    end
  end

  describe '#build_short_url' do
    let(:link) { service.build_short_url }

    it 'returns a Link object' do
      expect(link).to be_a(Link)
    end

    it 'sets the original_url' do
      expect(link.original_url).to eq(original_url)
    end

    it 'sets a unique short_url' do
      allow(SecureRandom).to receive(:alphanumeric).and_return('abc123')
      expect(link.short_url).to eq('abc123')
    end

    it 'sets the title from the provided title or fetched title' do
      expect(link.title).to eq(title)
    end

    it 'sets the title by fetching it from the URL if not provided' do
      service_without_title = described_class.new(original_url)
      allow(service_without_title).to receive(:fetch_title_from_url).and_return('Fetched Title')
      link_without_title = service_without_title.build_short_url
      expect(link_without_title.title).to eq('Fetched Title')
    end

    it 'sets the icon_url' do
      expect(link.icon_url).to eq("https://www.google.com/s2/favicons?domain=#{URI.parse(original_url).host}&sz=32")
    end
  end

  describe '#fetch_title' do
    it 'fetches the title from the URL' do
      allow(service).to receive(:fetch_title_from_url).and_return('Fetched Title')
      expect(service.fetch_title).to eq('Fetched Title')
    end
  end

  describe 'private methods' do
    describe '#generate_unique_short_url' do
      it 'generates a unique short_url' do
        allow(SecureRandom).to receive(:alphanumeric).and_return('abc123')
        allow(Link).to receive(:exists?).with(short_url: 'abc123').and_return(false)
        expect(service.send(:generate_unique_short_url)).to eq('abc123')
      end
    end

    describe '#fetch_title_from_url' do
      it 'fetches the title from the URL' do
        response = instance_double(HTTParty::Response,
                                   body: '<html><head><title>Example Title</title></head></html>')
        allow(HTTParty).to receive(:get).with(original_url).and_return(response)
        expect(service.send(:fetch_title_from_url, original_url)).to eq('Example Title')
      end

      it 'returns "No Title" if an error occurs' do
        allow(HTTParty).to receive(:get).with(original_url).and_raise(StandardError)
        expect(service.send(:fetch_title_from_url, original_url)).to eq('No Title')
      end
    end

    describe '#original_url_icon' do
      it 'generates the favicon URL' do
        expect(service.send(:original_url_icon, original_url)).to eq("https://www.google.com/s2/favicons?domain=#{URI.parse(original_url).host}&sz=32")
      end
    end
  end
end
