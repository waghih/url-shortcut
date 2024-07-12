require 'rails_helper'

RSpec.describe RecordVisitWorker, type: :worker do
  let(:link) { create(:link) }
  let(:geolocation_data) { { ip: '123.45.67.89', country: 'MY' }.to_json }

  describe 'perform' do
    it 'creates a visit with the correct attributes' do
      expect do
        described_class.new.perform(link.id, geolocation_data)
      end.to change(Visit, :count).by(1)

      visit = Visit.last
      expect(visit.link_id).to eq(link.id)
      expect(JSON.parse(visit.geolocation)).to include('ip' => '123.45.67.89', 'country' => 'MY')
    end
  end

  describe 'sidekiq integration' do
    it 'enqueues the job' do
      expect do
        described_class.perform_async(link.id, geolocation_data)
      end.to enqueue_sidekiq_job
    end
  end
end
