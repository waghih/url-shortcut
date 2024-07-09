class Visit < ApplicationRecord
  belongs_to :link
  validates :timestamp, presence: true
end
