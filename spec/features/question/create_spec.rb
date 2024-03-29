require 'rails_helper'

feature "User is able to create question", %q{
  Authenticated user would like to ask question
  in order to seek help from community
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask new question'
    end

    scenario "Asks a question with correct data" do
      fill_in 'Title', with: 'Question Title'
      fill_in 'Body', with: 'Question Body'
      click_on 'Ask'

      expect(page).to have_content('Question was created successfully')
      expect(page).to have_content('Question Title')
      expect(page).to have_content('Question Body')
    end

    scenario "Asks question with errors" do
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Ask'

      expect(page).to have_content("Title can't be blank")
      expect(page).to have_content("Body can't be blank")
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Question Title'
      fill_in 'Body', with: 'Question Body'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'Asks questions with an award' do
      fill_in 'Title', with: 'Question Title'
      fill_in 'Body', with: 'Question Body'

      fill_in 'Award', with: 'Link Name Award'
      fill_in 'Link', with: 'https://photo.com'
      click_on 'Ask'

      expect(page).to have_content 'Question with an Award!'
    end
  end

  scenario "Unauthenticated user can't ask question" do
    visit questions_path

    expect(page).to_not have_content('Ask new question')
  end
end
