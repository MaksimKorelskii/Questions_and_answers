require 'rails_helper'

feature "User is able to delete his answer", %q{
  user would like to delete his answer
  in order to seek help from community
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }
  given!(:answers) { create(:answer, question: question, author: author) }

  scenario "User tries to delete his answer" do
    sign_in(author)

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content('Your answer has been successfully deleted.')
  end

  scenario "User tries to delete another's answer" do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content("You can't delete another's answer.")
  end

  scenario "Unauthenticated user tries to delete question" do
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end