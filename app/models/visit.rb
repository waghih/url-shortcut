class Visit < ApplicationRecord
  belongs_to :link
  validates :timestamp, presence: true

  def country
    geolocation['country']
  end
end
