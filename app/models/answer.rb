class Answer < ApplicationRecord
  include Rateable

  belongs_to :question, touch: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, as: :commentable, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank
  has_many_attached :files

  validates :body, presence: true

  after_create :notify_about_new_answer

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_as_best
    transaction do
      self.class.where(question_id: self.question_id).update_all(best: false)
      update(best: true)
      question.award&.update!(user: author)
    end
  end

  private

  def notify_about_new_answer
    return unless self.question.subscribers.exists?

    NewAnswerNotificationJob.perform_later(self)
  end
end
