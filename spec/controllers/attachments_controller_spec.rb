require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:false_user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:attachment) { create(:attachment, record: question, blob: blob) }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      it "destroys user's own attachment" do
        sign_in(user)

        expect { delete :destroy, params: { id: attachment }, format: :js }.to change(question.files, :count).by(-1)

      end

      it "doesn't destroy another's attachment" do
        sign_in(false_user)

        expect { delete :destroy, params: { id: attachment }, format: :js }.not_to change(question.files, :count)
      end

      it 'renders destroy view' do
        sign_in(user)
        delete :destroy, params: { id: attachment }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context "Unauthenticated user" do
      it "doesn't destroy another's attachment" do
        expect { delete :destroy, params: { id: attachment }, format: :js}.not_to change(question.files, :count)
      end
    end
  end
end
