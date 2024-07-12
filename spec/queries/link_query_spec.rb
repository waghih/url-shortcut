require 'rails_helper'

RSpec.describe LinkQuery, type: :model do
  let!(:link_first) { create(:link, short_url: 'abc123') }
  let(:link_second) { create(:link, short_url: 'def456') }
  let!(:link_with_visits) { create(:link, visits: create_list(:visit, 3)) }

  describe '#initialize' do
    it 'initializes with a relation' do
      query = described_class.new(Link.where(short_url: 'abc123'))
      expect(query.instance_variable_get(:@relation)).to eq(Link.where(short_url: 'abc123'))
    end
  end

  describe '#by_short_url' do
    it 'finds a link by short_url' do
      query = described_class.new
      result = query.by_short_url('abc123')
      expect(result).to eq(link_first)
    end

    it 'returns nil if no link is found' do
      query = described_class.new
      result = query.by_short_url('notexist')
      expect(result).to be_nil
    end
  end

  describe '#by_id' do
    it 'finds a link by id' do
      query = described_class.new
      result = query.by_id(link_first.id)
      expect(result).to eq(link_first)
    end

    it 'raises an error if no link is found' do
      query = described_class.new
      expect { query.by_id(0) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#with_visits' do
    it 'includes visits in the relation with geolocation data' do
      query = described_class.new
      result = query.with_visits.by_id(link_with_visits.id)
      expect(result.visits.size).to eq(3)
      result.visits.each do |visit|
        geolocation = JSON.parse(visit.geolocation)
        expect(geolocation).to have_key('country')
        expect(geolocation['country']).to match(/\A[A-Z]{2}\z/) # validate country code format
      end
    end
  end

  describe '#paginate' do
    it 'paginates the results' do
      query = described_class.new
      paginated_links = query.paginate(page: 1, per_page: 1)
      expect(paginated_links.size).to eq(1)
      expect(paginated_links.first).to eq(link_first)
    end
  end
end
