require 'rails_helper'

RSpec.describe Link, type: :model do
  it { is_expected.to validate_presence_of(:original_url) }
  it { is_expected.to have_many(:visits).dependent(:destroy) }
end
