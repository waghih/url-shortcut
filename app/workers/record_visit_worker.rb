class RecordVisitWorker
  include Sidekiq::Worker

  def perform(link_id, geolocation_data)
    Visit.create(
      link_id: link_id,
      geolocation: geolocation_data,
      timestamp: Time.zone.now
    )
  end
end
