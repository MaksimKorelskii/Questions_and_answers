require 'rails_helper'

feature 'User is able to log in through github', %q{
  User would like to be able to log in through github to speed up login process
} do

  given!(:user) { create(:user, email: 'name@mail.com') }
  background { visit new_user_session_path }

  describe 'github' do
    background do
      OmniAuth.config.mock_auth[:github] =
        OmniAuth::AuthHash.new(
          provider: 'github',
          uid: '1234',
          info: { email: 'name@mail.com' }
        )
    end

    scenario 'sign in with exist email' do
      click_on 'Sign in with GitHub'

      expect(page).to have_current_path(root_path)
    end

    scenario 'sign in with not exist email' do
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'name@mail.com'
    end
  end
end
