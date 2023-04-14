class Subscription < ApplicationRecord
  belongs_to :subscriber, class_name: 'User', foreign_key: 'subscriber_id'
  belongs_to :question

  validates :subscriber, :question, presence: true
  validates :subscriber, uniqueness: { scope: :question }
end
