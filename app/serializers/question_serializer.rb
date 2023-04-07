class QuestionSerializer < ActiveModel::Serializer
  attributes %i[ id title body author_id created_at updated_at short_title ]
  has_many :answers
  belongs_to :author

  def short_title
    object.title.truncate(7)
  end
  
end
