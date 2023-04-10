class QuestionSerializer < ActiveModel::Serializer
  attributes %i[ id title body author_id comments links created_at updated_at ]
  
  # belongs_to :author, class_name: 'User'
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
