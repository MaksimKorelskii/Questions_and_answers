require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    let(:params_hash) { { search_query: 'Query string', search_by: 'all' } }
    let(:params) { ActionController::Parameters.new(params_hash).permit! }

    before do
      expect(SearchService).to receive(:call).with(params)

      get :index, params: params_hash
    end

    it 'returns 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'render index' do
      expect(response).to render_template :index
    end
  end
end
