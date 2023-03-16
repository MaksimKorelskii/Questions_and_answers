require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: author) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      it "destroys user's own link" do
        login(author)

        expect { delete :destroy, params: { id: link }, format: :js }.to change(question.links, :count).by(-1)
      end

      it "doesn't destroy another's link" do
        login(user)

        expect { delete :destroy, params: { id: link }, format: :js }.not_to change(question.links, :count)
      end

      it 'renders destroy view' do
        login(author)
        delete :destroy, params: { id: link }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'Unauthenticated user' do
      it "doesn't destroy another's link" do
        expect { delete :destroy, params: { id: link }, format: :js }.not_to change(question.links, :count)
      end
    end
  end
end
