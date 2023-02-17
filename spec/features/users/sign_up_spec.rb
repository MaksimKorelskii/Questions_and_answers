require 'rails_helper'

feature 'User can sign up', %q{
  User would like to Sign Up
  to be an authenticated user
  in order to ask questions
} do
  background { visit new_user_registration_path }

  scenario 'User tries to sign up with valid params' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully'
  end

  scenario 'User tries to sign up with invalid params (Password confirmation does not match Password)' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '654321'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'User tries to sign up with invalid email' do
    fill_in 'Email', with: 'usertest.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content "Email is invalid"
  end

  scenario 'User tries to sign up with short password' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '123'
    click_on 'Sign up'

    expect(page).to have_content "Password is too short (minimum is 6 characters)"
  end
end
