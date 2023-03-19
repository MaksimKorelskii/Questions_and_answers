class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :rateable, polymorphic: true

  validates :value, presence: true
  validates :user, presence: true, uniqueness: { scope: %i[rateable_id rateable_type] }
end
