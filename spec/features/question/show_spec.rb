require 'rails_helper'

feature "User can visit page with question", %q{
  In order to view answers to selected question
  to solve his problem
  user can visit page with question's answers
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario "User visits question page" do
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
  end
end
