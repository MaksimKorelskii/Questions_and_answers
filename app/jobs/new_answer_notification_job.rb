class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(new_answer)
    NewAnswerNotificationService.new.notificate(new_answer)
  end
end
