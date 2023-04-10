class AnswerSerializer < ActiveModel::Serializer
  attributes %i[ id body author_id question_id best comments links created_at updated_at ]
  
  # belongs_to :author, class_name: 'User'
  # belongs_to :question
  has_many :comments, if: -> { object.comments.present? }

  def links
    object.links.pluck(:url)
  end

  # def files
  #   object.files.map do |file|
  #     { 'id'   => file.id,
  #       'name' => file.filename.to_s,
  #       'url'  => file.url }
  #   end
  # end  
end
