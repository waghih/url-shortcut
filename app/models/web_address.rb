class WebAddress < ApplicationRecord
  validates :original_url, presence: true
end
