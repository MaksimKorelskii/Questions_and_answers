require 'rails_helper'

feature 'User can rate the answer', "
  In order to show appreciation or discontent
  user would like to rate the answer
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  describe 'Not an author of the question', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'rates the question positively' do
      within '.answers' do
        click_on 'Uprate'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'rates the question negatively' do
      within '.answers' do
        click_on 'Downrate'

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'cancels his rating' do
      within '.answers' do
        click_on 'Uprate'
        click_on 'Cancel'

        within '.rating' do
          expect(page).to have_content '0'
        end
      end
    end
  end

  describe 'Author of question', js: true do
    background do
      sign_in author
      visit question_path(question)
    end

    scenario 'tries to rate his question positively' do
      within '.answers' do
        expect(page).to_not have_link 'Uprate'
      end
    end

    scenario 'tries to rate his question negatively' do
      within '.answers' do
        expect(page).to_not have_link 'Downrate'
      end
    end

    scenario 'tries to cancel the rating' do
      within '.answers' do
        expect(page).to_not have_link 'Cancel'
      end
    end
  end

  describe 'Unauthorized user' do
    background { visit question_path(question) }

    scenario 'tries to rate the question positively' do
      within '.answers' do
        expect(page).to_not have_link 'Uprate'
      end
    end

    scenario 'tries to rate the question negatively' do
      within '.answers' do
        expect(page).to_not have_link 'Downrate'
      end
    end

    scenario 'tries to cancel the rating' do
      within '.answers' do
        expect(page).to_not have_link 'Cancel'
      end
    end
  end
end
