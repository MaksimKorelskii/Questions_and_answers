class AnswersSerializer < ActiveModel::Serializer
  attributes %i[ id body author_id question_id best created_at updated_at ]
  
  # belongs_to :author, class_name: 'User'
  # belongs_to :question
end
