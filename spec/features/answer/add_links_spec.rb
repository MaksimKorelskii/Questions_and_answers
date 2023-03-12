require 'rails_helper'

feature "User can add links to answer", %q{
  In order to provide additional info to my answer
  As a answer's author
  I'd like to be able to add links
} do

  given(:gist_url) { 'https://gist.github.com/MaksimKorelskii/855ae3036d8ed8d2c386b09323620697' }
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in "Body", with: "Answer Body"
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on "Answer"

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end  
end
