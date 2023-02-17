require 'rails_helper'

feature 'User can sign out', %q{
  User would like to Sign Out
} do
  given(:user) { create(:user) }

  background do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  scenario 'Registered user tries to sign out' do
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
