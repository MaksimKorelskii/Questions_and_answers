class AnswersSerializer < ActiveModel::Serializer
  attributes %i[ id body author_id question_id best created_at updated_at ]
end
