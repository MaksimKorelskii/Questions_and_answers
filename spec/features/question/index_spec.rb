require 'rails_helper'

feature 'User can view list of the questions', %q{
  In order search solution for task
  I'd like to be able view questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, author: user) }

  scenario 'User views questions' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
