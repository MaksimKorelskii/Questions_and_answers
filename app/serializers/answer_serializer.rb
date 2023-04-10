class AnswerSerializer < ActiveModel::Serializer
  attributes %i[ id body author_id question_id best comments links created_at updated_at ]
  
  has_many :comments, if: -> { object.comments.present? }

  def links
    object.links.pluck(:url)
  end
end
