class NewAnswerNotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_answer_notification_mailer.notificate.subject
  #
  def notificate(subscriber, question, new_answer)
    @question = question
    @new_answer = new_answer
    @subscriber = subscriber

    mail to: subscriber.email
  end
end
