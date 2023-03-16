class Award < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  validates :name, :link, presence: true
end
