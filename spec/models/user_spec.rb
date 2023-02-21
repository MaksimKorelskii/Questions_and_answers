require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  describe "author?" do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, author: author)}
    let(:answer) { create(:answer, author: author, question: question) }

    it "is expected user is the author of resource" do
      expect(author.author?(answer)).to be true
      expect(author.author?(question)).to be true
    end

    it "is expected user isn't the author of resource" do
      expect(user.author?(answer)).to be false
      expect(user.author?(question)).to be false
    end
  end
end
