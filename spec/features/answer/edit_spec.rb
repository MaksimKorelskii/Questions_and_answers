require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    context 'Author' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'edits his answer', js: true do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his answer with errors', js: true do    
        within '.answers' do
          click_on 'Edit'
          fill_in 'Body', with: ''
          click_on 'Save'
  
          expect(page).to have_content(answer.body)
        end
  
        within '.answer-errors' do
          expect(page).to have_content("Body can't be blank")
        end
      end

      scenario 'edits his answer by adding attached files', js: true do
        within '.answers' do
          click_on 'Edit'

          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    context 'Not author' do
      scenario "tries to edit other user's question", js: true do
        sign_in(user)
        visit question_path(question)
  
        within '.answers' do
          expect(page).not_to have_content('Edit')
        end
      end
    end
  end
end
