class QuestionsSerializer < ActiveModel::Serializer
  attributes %i[ id title body author_id created_at updated_at short_title ]
  
  belongs_to :author, class_name: 'User'
  has_many :answers, if: -> { object.answers.present? }

  def short_title
    object.title.truncate(7)
  end
end
