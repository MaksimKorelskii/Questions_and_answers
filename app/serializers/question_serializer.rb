class QuestionSerializer < ActiveModel::Serializer
  attributes %i[ id title body author_id comments links created_at updated_at ]
  
  has_many :comments, if: -> { object.comments.present? }

  def links
    object.links.pluck(:url)
  end
end
