require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:author) { create :user }
  let(:new_answer_notification_service) { double('NewAnswerNotificationService') }
  let(:question) { create(:question, author: author) }
  let(:new_answer) { create(:answer, question: question, author: question.author) }

  before do
    allow(NewAnswerNotificationService).to receive(:new).and_return(new_answer_notification_service)
  end

  it 'calls NewAnswerNotificationService#notificate' do
    expect(new_answer_notification_service).to receive(:notificate)

    NewAnswerNotificationJob.perform_now(new_answer)
  end
end
