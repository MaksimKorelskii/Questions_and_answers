require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT'       => 'application/json' }
  end

  describe 'GET api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end
    
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/profiles/me', headers: headers

        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: '1234' }, headers: headers

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all publick fields' do
        # везду далее json это helper ( json = JSON.parse(response.body) )

        %w[ id email admin created_at updated_at ].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
          # expect(json['id']).to eq me.id
        end
      end

      it 'does not returns private fields' do
        %w[ password encrypted_password ].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id).token }

      before do
        get api_path,
            params: { access_token: access_token },
            headers: headers
      end

      it_behaves_like 'Status be_successful'

      it_behaves_like 'Returns all public fields' do
        let(:attributes) { %w[id email admin] }
        let(:resource) { json }
        let(:object) { me }
      end

      it_behaves_like 'Does not return private fields'
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:users) { create_list(:user, 4) }
      let(:me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id).token }

      before do
        get api_path,
            params: { access_token: access_token },
            headers: headers
      end

      it_behaves_like 'Status be_successful'

      it 'list of users does not include me' do
        ids = json.pluck('id')

        expect(ids).to_not include(me.id)
      end

      it 'returns list of users ex me' do
        expect(json.size).to eq 3
      end

      it_behaves_like 'Returns all public fields' do
        let(:attributes) { %w[id email admin] }
        let(:resource) { json.last }
        let(:object) { users.last }
      end
    end
  end
end
