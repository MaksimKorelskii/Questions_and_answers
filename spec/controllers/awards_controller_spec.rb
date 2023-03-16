require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question, author: user }

  describe 'GET #index' do
    let!(:questions) { create_list :award, 3, user: user, question: question }

    before do
      sign_in(user)
      get :index
    end

    it 'populates an array of all questions' do
      expect(assigns(:awards)).to match_array(user.awards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end