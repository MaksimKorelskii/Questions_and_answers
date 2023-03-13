require 'rails_helper'

feature "Authenticated user can create answers", %q{
  In order to help other users or clarify question
  user can create answers
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, author: author) }

  describe "Authenticated user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "Tries to create answer", js: true do
      fill_in "Body", with: "MyText"
      click_on "Answer"

      expect(current_path).to eq question_path(question)
      within '.answers' do # чтобы убедиться, что ответ в списке, а не в форме
        expect(page).to have_content("MyText")
      end
    end

    scenario "Tries to create answer with invalid params", js: true do
      fill_in "Body", with: ""
      click_on "Answer"

      expect(page).to have_content("Body can't be blank")
    end

    scenario 'create a answer with attached file', js: true do
      fill_in 'Body', with: 'Answer Body'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario "Unauthenticated user Tries to create answer", js: true do
    visit question_path(question)

    expect(page).not_to have_content("Send Answer")
  end
end
