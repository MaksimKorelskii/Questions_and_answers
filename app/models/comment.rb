class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :user, :content, presence: true
end
