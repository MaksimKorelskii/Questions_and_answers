require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT'       => 'application/json' }
  end

  let!(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id).token }
  let!(:question) { create(:question, author: user) }
  let(:question_id) { question.id }
  let!(:answer) { create(:answer, question: question, author: user) }
  let(:answer_id) { answer.id }

  describe '/api/v1/questions/:question_id/answers' do
    let!(:author) { create(:user) }
    let!(:answers) { create_list(:answer, 4, question: question, author: author) }
    let(:answer) { answers.first }
    let(:answers_response) { json['answers'] }
    let(:api_path) { "/api/v1/questions/#{question_id}/answers" }
  
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
  
      it_behaves_like 'API List' do
        let(:resource) { answers_response }
        let(:list_size) { 4 }
      end
  
      it_behaves_like 'Returns all public fields' do
        let(:attributes) { %w[id author_id body created_at updated_at] }
        let(:resource) { answers_response.first }
        let(:object) { answer }
      end
    end
  end


  describe '/api/v1/answers/:answer_id/' do
    let(:api_path) { "/api/v1/answers/#{answer_id}" }
    let(:answer_response) { json['answer'] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    describe 'GET' do
      let!(:comments) { create_list(:comment, 4, commentable: answer, user: user) }
      let!(:links) { create_list(:link, 4, linkable: answer) }

      before do
        get api_path,
            params: { access_token: access_token },
            headers: headers
      end

      it_behaves_like 'Status be_successful'

      context 'Links' do
        let(:link) { links.first }
        let(:link_response) { answer_response['links'].last }

        it_behaves_like 'API List' do
          let(:resource) { answer_response['links'] }
          let(:list_size) { 4 }
        end
      end

      context 'Comments' do
        let(:comment) { comments.first }
        let(:comment_response) { answer_response['comments'].first }

        it_behaves_like 'API List' do
          let(:resource) { answer_response['comments'] }
          let(:list_size) { 4 }
        end
      end
    end

    describe 'POST' do
      let(:api_path) { "/api/v1/questions/#{question_id}/answers" }

      it_behaves_like 'API Authorizable' do
        let(:headers) { { 'ACCEPT' => 'application/json' } }
        let(:method) { :post }
      end

      context 'with valid attributes' do
        it '201 status' do
          post api_path, params: { access_token: access_token,
                                   headers: headers,
                                   answer: { body: 'Answer text' } }

          expect(response).to have_http_status(201)
        end

        it 'create a new answer' do
          expect do
            post api_path, params: { access_token: access_token,
                                     headers: headers,
                                     answer: { body: 'Answer text' } }
          end.to change(question.answers, :count).by(1)
        end
      end

      context 'with not valid attributes' do
        it '422 status' do
          post api_path, params: { access_token: access_token,
                                   headers: headers,
                                   answer: { body: '' } }

          expect(response).to have_http_status(422)
        end

        it 'dont create a new answer' do
          expect do
            post api_path, params: { access_token: access_token,
                                     headers: headers,
                                     answer: { body: '' } }
          end.to_not change(question.answers, :count)
        end
      end
    end

    describe 'PATCH' do
      let(:api_path) { "/api/v1/answers/#{answer_id}" }
      let(:edited_answer_text) { 'Edited answer text' }

      it_behaves_like 'API Authorizable' do
        let(:headers) { { 'ACCEPT' => 'application/json' } }
        let(:method) { :patch }
      end

      it '200 status' do
        patch api_path, params: { access_token: access_token,
                                  headers: headers,
                                  answer: { body: edited_answer_text } }

        expect(response).to be_successful
      end

      it 'change answer text' do
        patch api_path, params: { access_token: access_token,
                                  headers: headers,
                                  answer: { body: edited_answer_text } }

        answer.reload

        expect(answer.body).to eq edited_answer_text
      end
    end

    describe 'DELETE' do
      let(:headers) { { 'ACCEPT' => 'application/json' } }
      let(:api_path) { "/api/v1/answers/#{answer_id}" }

      it_behaves_like 'API Authorizable' do
        let(:headers) { { 'ACCEPT' => 'application/json' } }
        let(:method) { :delete }
      end

      it '200 status' do
        delete api_path, params: { access_token: access_token },
                                   headers: headers

        expect(response).to have_http_status(200)
      end

      it 'delete answer' do
        expect do
          delete api_path, params: { access_token: access_token },
                                     headers: headers
        end.to change(question.answers, :count).by(-1)
      end
    end
  end
end
