require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }
    
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show views' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #index' do
    let(:questions) { create_list :question, 3, author: user }
    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create :question, author: user }
    let(:answer) { create :answer, author: user }
    before { get :show, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create :user }
    let!(:question) { create :question, author: author }

    context "User is the author of the question" do
      before { login(author) }

      it 'Author deletes the question from database' do
        expect { delete :destroy, params: { id: question} }.to change(Question, :count).by(-1)
      end

      it 'redirects to questions' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context "User isn't the author of the question" do
      before { login(user) }

      it 'User tries to delete the question from database' do
        expect { delete :destroy, params: { id: question} }.not_to change(Question, :count)
      end

      it 'redirects to questions' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe 'PATCH #update' do
    before { login(author) }
    let!(:question) { create :question, author: author }

    context 'with valid attributes' do
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js

        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.to_not change(question, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end
end
