class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    @questions = Question.all
    # render json: @questions
    # render json: @questions.to_json(include: %i[ answers ])
    render json: @questions
    # render json: @questions, serializer: <имя класса сериалайзера> для объекта
    # render json: @questions, each_serializer: <имя класса сериалайзера> для коллекции
  end
end
