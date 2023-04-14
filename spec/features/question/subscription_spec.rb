require 'rails_helper'

feature 'User can subscribe to new answers to the question' do
  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question, author: author) }

  describe 'Authenticated user' do
    context 'if he is the not author of the question' do
      background do
        sign_in(not_author)
        visit question_path(question)
      end

      scenario 'can subscribe for notifications of new answers', js: true do
        expect(page).to     have_link 'Subscribe'
        expect(page).to_not have_link 'Unsubscribe'

        click_on 'Subscribe'

        expect(page).to     have_link 'Unsubscribe'
        expect(page).to_not have_link 'Subscribe'
      end

      scenario 'can unsubscribe for notifications of new answers', js: true do
        click_on 'Subscribe'

        expect(page).to     have_link 'Unsubscribe'
        expect(page).to_not have_link 'Subscribe'

        click_on 'Unsubscribe'

        expect(page).to     have_link 'Subscribe'
        expect(page).to_not have_link 'Unsubscribe'
      end
    end
  end
end
