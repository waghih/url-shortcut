class Link < ApplicationRecord
  validates :original_url, presence: true
end
