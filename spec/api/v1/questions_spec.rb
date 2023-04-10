require 'rails_helper'

describe 'Question API', type: :request do
  let(:author) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: author.id).token }

  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT'       => 'application/json' }
  end

  describe 'GET api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:author) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, author: author) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3,question: question, author: author)}

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        # везду далее json это helper ( json = JSON.parse(response.body) )

        %w[ title body author_id created_at updated_at ].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end
      
      describe 'answer' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end
  
        it 'returns all public fields' do
  
          %w[ id body author_id created_at updated_at ].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end




  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:headers) { { 'ACCEPT' => 'application/json' } }
      let(:method) { :post }
    end

    context 'with valid attributes' do
      let(:question_post) do
        post api_path, params: { access_token: access_token,
                                 headers: headers,
                                 question: { title: 'Question title',
                                             body:  'Question text' } }
      end

      it '201 status' do
        question_post

        expect(response).to have_http_status(201)
      end

      it 'create a new question' do
        expect{ question_post }.to change(Question, :count).by(1)
      end
    end

    context 'with not valid attributes' do
      let(:question_post) do
        post api_path, params: { access_token: access_token,
                                 headers: headers,
                                 question: { title: '',
                                             body:  '' } }
      end

      it '422 status' do
        question_post

        expect(response).to have_http_status(422)
      end

      it 'dont create a new question' do
        expect{ question_post }.to_not change(Question, :count)
      end
    end
  end

  describe '/api/v1/questions/:question_id' do
    let!(:question) { create(:question, author: author) }
    let(:question_id) { question.id }
    let!(:comments) { create_list(:comment, 4, commentable: question, user: author) }
    let!(:links) { create_list(:link, 4, linkable: question) }
    let(:question_response) { json['question'] }
    let(:api_path) { "/api/v1/questions/#{question_id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    describe 'GET' do
      before do
        get api_path,
            params: { access_token: access_token },
            headers: headers
      end

      it_behaves_like 'Status be_successful'

      it_behaves_like 'Returns all public fields' do
        let(:attributes) { %w[id title body] }
        let(:resource) { question_response }
        let(:object) { question }
      end

      context 'Links' do
        let(:link) { links.first }
        let(:link_response) { question_response['links'].last }

        it_behaves_like 'API List' do
          let(:resource) { question_response['links'] }
          let(:list_size) { 4 }
        end
      end

      context 'Comments' do
        let(:comment) { comments.first }
        let(:comment_response) { question_response['comments'].first }

        it_behaves_like 'API List' do
          let(:resource) { question_response['comments'] }
          let(:list_size) { 4 }
        end
      end
    end

    describe 'PATCH' do
      before do
        patch api_path, params: { access_token: access_token,
                                  headers: headers,
                                  question: { title: 'Edited title text',
                                              body: 'Edited question text' } }
      end

      it_behaves_like 'Status be_successful'

      it '200 status' do
        expect(response).to be_successful
      end

      it 'change question text' do
        question.reload

        expect(question.body).to eq 'Edited question text'
      end
    end

    describe 'DELETE' do
      let(:headers) { { 'ACCEPT' => 'application/json' } }
      let(:delete_question) do
        delete api_path, params: { access_token: access_token },
                                   headers: headers
      end

      it_behaves_like 'API Authorizable' do
        let(:headers) { { 'ACCEPT' => 'application/json' } }
        let(:method) { :delete }
      end

      it '200 status' do
        delete_question

        expect(response).to have_http_status(200)
      end

      it 'delete question' do
        expect{ delete_question }.to change(Question, :count).by(-1)
      end
    end
  end
end
