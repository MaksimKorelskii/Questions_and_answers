require 'rails_helper'

feature 'User can view list of the questions', %q{
  In order search solution for task
  I'd like to be able view questions
} do

  given!(:questions) { create_list(:question, 3) }

  scenario 'User views questions' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.body
    end
  end
end
