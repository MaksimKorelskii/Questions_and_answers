require 'rails_helper'

feature 'User can rate the question', "
  In order to show appreciation or discontent
  user would like to rate the question
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe 'Not an author of the question', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'rates the question positively' do
      click_on 'Uprate'

      within '.rating' do
        expect(page).to have_content '1'
      end
    end

    scenario 'rates the question negatively' do
      click_on 'Downrate'

      within '.rating' do
        expect(page).to have_content '-1'
      end
    end

    scenario 'cancels his rating' do
      click_on 'Uprate'
      click_on 'Cancel'

      within '.rating' do
        expect(page).to have_content '0'
      end
    end
  end

  describe 'Author of question', js: true do
    background do
      sign_in author
      visit question_path(question)
    end

    scenario 'tries to rate his question positively' do
      expect(page).to_not have_link 'Uprate'
    end

    scenario 'tries to rate his question negatively' do
      expect(page).to_not have_link 'Downrate'
    end

    scenario 'tries to cancel the rating' do
      expect(page).to_not have_link 'Cancel'
    end
  end

  describe 'Unauthorized user' do
    background { visit questions_path }

    scenario 'tries to rate the question positively' do
      expect(page).to_not have_link 'Uprate'
    end

    scenario 'tries to rate the question negatively' do
      expect(page).to_not have_link 'Downrate'
    end

    scenario 'tries to cancel the rating' do
      expect(page).to_not have_link 'Cancel'
    end
  end
end
