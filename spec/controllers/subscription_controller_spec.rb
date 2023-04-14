require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question, author: user) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    it 'create subscription' do
      expect do
        post :create, params: { question_id: question }, format: :js
      end.to change(user.subscriptions, :count).from(0).to(1)
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, subscriber: user, question: question) }

    it 'delete subscription' do
      expect do
        delete :destroy, params: { id: subscription }, format: :js
      end.to change(user.subscriptions, :count).from(1).to(0)
    end
  end
end
