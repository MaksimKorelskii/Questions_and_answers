require 'rails_helper'

feature "Authenticated user can create answers", %q{
  In order to help other users or clarify question
  user can create answers
} do

  given(:user) { create(:user) }
  # given(:author) { create(:user, :confirmed_user) }
  given(:question) { create(:question) }

  describe "Authenticated user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "Tries to create answer" do
      fill_in "Body", with: "MyText"
      click_on "Answer"

      expect(page).to have_content("MyText")
    end

    scenario "Tries to create answer with invalid params" do
      fill_in "Body", with: ""
      click_on "Answer"

      expect(page).to have_content("Body can't be blank")
    end
  end

  scenario "Unauthenticated user Tries to create answer" do
    visit question_path(question)

    fill_in "Body", with: "MyText"
    click_on "Answer"

    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end
end
