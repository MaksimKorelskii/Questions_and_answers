class DailyDigestService
  def send_digest
    questions = Question.where('created_at >= ?', 1.day.ago).pluck(:title)

    return if questions.empty?

    User.find_each(batch_size: 100) do |user|
      DailyDigestMailer.digest(user, questions).deliver_later
    end
  end
end
