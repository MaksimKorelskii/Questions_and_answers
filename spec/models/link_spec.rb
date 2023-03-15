require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#url' do
    it { should allow_value('https://gist.github.com').for(:url) }
    it { should_not allow_value('foobar').for(:url) }
  end
end
