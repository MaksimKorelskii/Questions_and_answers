require 'rails_helper'

feature 'User is able to log in through vk', %q{
  User would like to be able to log in through vk to speed up login process
} do

  given!(:user) { create(:user, email: 'name@mail.com') }
  background { visit new_user_session_path }

  describe 'VK' do
    background do
      OmniAuth.config.mock_auth[:vkontakte] =
        OmniAuth::AuthHash.new(
          provider: 'vkontakte',
          uid: '1234',
          info: { email: 'name@mail.com' }
        )
    end

    scenario 'sign in with exist email' do
      click_on 'Sign in with Vkontakte'

      expect(page).to have_current_path(root_path)
    end

    scenario 'sign in with not exist email' do
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'name@mail.com'
    end
  end
end
