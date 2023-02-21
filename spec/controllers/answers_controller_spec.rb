require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'redirect to questions#show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create :user }
    let!(:answer) { create :answer, author: author, question: question }

    context "User is the author of the answer" do
      before { login(author) }

      it 'Author deletes the answer from database' do
        expect { delete :destroy, params: { id: answer} }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question/show' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context "User isn't the author of the answer" do
      before { login(user) }

      it 'User tries to delete the answer from database' do
        expect { delete :destroy, params: { id: answer} }.not_to change(Answer, :count)
      end

      it 'redirects to question/show' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
