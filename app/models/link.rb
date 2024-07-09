class Link < ApplicationRecord
  validates :original_url, presence: true
  has_many :visits, dependent: :destroy
end
