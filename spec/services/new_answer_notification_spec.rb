require 'rails_helper'

RSpec.describe NewAnswerNotificationService do
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:new_answer) { create(:answer, question: question, author: author) }
  let(:subscriber) { create(:user) }
  let!(:subscription) { create(:subscription, subscriber: subscriber, question: question) }

  it 'sends new answer to all subscribers' do
    expect(NewAnswerNotificationMailer).to receive(:notificate)
                                             .with(subscriber, question, new_answer)
                                             .and_call_original

    subject.notificate(new_answer)
  end
end
