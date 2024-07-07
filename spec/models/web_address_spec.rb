require 'rails_helper'

RSpec.describe WebAddress, type: :model do
  it { is_expected.to validate_presence_of(:original_url) }
end
