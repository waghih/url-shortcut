require 'rails_helper'

RSpec.describe Visit, type: :model do
  it { is_expected.to belong_to(:link) }
  it { is_expected.to validate_presence_of(:timestamp) }
end
