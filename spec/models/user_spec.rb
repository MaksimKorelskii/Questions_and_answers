require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).with_foreign_key('subscriber_id').dependent(:destroy) }

  describe '#admin!' do
    let!(:user) { create(:user, admin: false) }
    before { user.admin! }

    it { expect(user).to be_admin }
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: 'test') }
    let(:service) { double('FindForOauthService') } # это мок - фейковый объект, умеет принимать и обрабатывать стабы без реализации (как например вызов метода #call)

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#author?' do
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
