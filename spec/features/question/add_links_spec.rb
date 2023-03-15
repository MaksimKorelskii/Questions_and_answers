require 'rails_helper'

feature "User can add links to question", %q{
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/MaksimKorelskii/855ae3036d8ed8d2c386b09323620697' }

  scenario 'User adds links when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Question Title'
    fill_in 'Body', with: 'Question Body'

    click_on 'add link'
    
    within '.attachable-links' do
      fill_in 'Name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
