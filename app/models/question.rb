class Question < ApplicationRecord
  include Rateable
  
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  has_one :award, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, as: :commentable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation

  private

  def calculate_reputation
    # ReputationService.calculate(self) # перенесли в job
    ReputationJob.perform_later(self)
  end
end
