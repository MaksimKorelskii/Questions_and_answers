require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to(:user).optional(true) }
  it { should belong_to :question }

  it { should validate_presence_of :name }
  it { should validate_presence_of :link }
end
