require 'rails_helper'

feature "User is able to delete his answer", %q{
  user would like to delete his answer
  in order to seek help from community
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  scenario "User tries to delete his answer", js: true do
    sign_in(author)
    visit question_path(question)
    
    click_on 'Delete'

    expect(page).not_to have_content answer.body
  end

  scenario "User tries to delete another's answer" do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content('Delete')
    end
  end

  scenario "Unauthenticated user tries to delete answer" do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content('Delete')
    end
  end
end
