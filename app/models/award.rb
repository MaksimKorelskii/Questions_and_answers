class Award < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :name, :link, presence: true
end
