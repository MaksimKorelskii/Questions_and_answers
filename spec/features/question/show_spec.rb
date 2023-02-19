require 'rails_helper'

feature "User can visit page with question answers", %q{
  In order to view answers to selected question
  to solve his problem
  user can visit page with question's answers
}do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario "User visits question page" do
    visit question_path(question)

    expect(page).to have_content(answers[0].body)
    expect(page).to have_content(answers[1].body)
    expect(page).to have_content(answers[2].body)
  end
end
