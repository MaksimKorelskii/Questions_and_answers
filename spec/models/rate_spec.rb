require 'rails_helper'

RSpec.describe Rate, type: :model do
  it { should belong_to :user }
  it { should belong_to :rateable }

  it { should validate_presence_of :value }
end
