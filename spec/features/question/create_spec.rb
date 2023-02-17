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
      click_on 'Ask question'
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
  end

  scenario "Unauthenticated user can't ask question" do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
