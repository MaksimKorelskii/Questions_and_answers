require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(Answer, :count).by(1)
      end

      it 'redirect to questions#show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create :user }
    let!(:answer) { create :answer, author: author, question: question }

    context "User is the author of the answer" do
      before { login(author) }

      it 'Author deletes the answer from database' do
        expect { delete :destroy, params: { id: answer}, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question/show' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "User isn't the author of the answer" do
      before { login(user) }

      it 'User tries to delete the answer from database' do
        expect { delete :destroy, params: { id: answer}, format: :js }.not_to change(Answer, :count)
      end

      it 'redirects to root_path' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe "PATCH #mark_as_best" do
    let(:user2) { create(:user) }
    let!(:answer) { create(:answer, author: user2, question: question) }
    let(:answer2) { create(:answer, author: user2, question: question, best: true) }

    context "author of question" do
      it "marks the answer as best" do
        sign_in(user)
        patch :mark_as_best, params: { id: answer}, format: :js
        
        expect { answer.reload }.to change { answer.best }
      end

      it "marks the answer as best even if another best answer exists" do
        answer2
        sign_in(user)
        patch :mark_as_best, params: { id: answer}, format: :js

        expect { answer.reload }.to change { answer.best }
        expect { answer2.reload }.to change { answer2.best }
      end
    end

    context "non-author" do
      it "doesn't mark the answer as best" do
        sign_in(user2)
        patch :mark_as_best, params: { id: answer}, format: :js

        expect { answer.reload }.not_to change { answer.best }
      end
    end

    it "renders mark_as_best_view" do
      sign_in(user)
      patch :mark_as_best, params: { id: answer}, format: :js

      expect(response).to render_template :mark_as_best
    end
  end
end
