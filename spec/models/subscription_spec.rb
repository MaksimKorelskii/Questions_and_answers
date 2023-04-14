require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:subscriber).class_name('User').with_foreign_key('subscriber_id') }
  it { should belong_to(:question) }

  it { should validate_presence_of :subscriber }
  it { should validate_presence_of :question }
end
