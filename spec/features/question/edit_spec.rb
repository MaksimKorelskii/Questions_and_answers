require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    context 'Author' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'edits his question', js: true do
        within '.question' do
          click_on 'Edit'
          fill_in 'Title', with: 'edited title'
          fill_in 'Your question', with: 'edited question'
          click_on 'Save'

          expect(page).to_not have_content question.title
          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited title'
          expect(page).to have_content 'edited question'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his question by adding attached files', js: true do
        within '.question' do
          click_on 'Edit'

          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'edits his question with errors', js: true do    
        within '.question' do
          click_on 'Edit'
          fill_in 'Title', with: ''
          fill_in 'Your question', with: ''
          click_on 'Save'
  
          expect(page).to have_content(question.body)
        end
  
        within '.question-errors' do
          expect(page).to have_content("Body can't be blank")
        end
      end
    end

    context 'Not author' do
      scenario "tries to edit other user's question", js: true do
        sign_in(user)
        visit question_path(question)
  
        within '.question' do
          expect(page).not_to have_content('Edit')
        end
      end
    end
  end
end
