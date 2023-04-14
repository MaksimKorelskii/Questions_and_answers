require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user, questions) }
    let(:questions) { create_list(:question, 3, author: user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to) == (user.email)
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New questions for a day")
    end

    it 'renders questions titles' do
      questions.each do |question|
        expect(mail.body.encoded).to have_content question.title
      end
    end
  end
end
