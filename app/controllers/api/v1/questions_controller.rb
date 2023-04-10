class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[ show update destroy ]
  # skip_before_action :verify_authenticity_token
  authorize_resource

  def index
    @questions = Question.all
    # render json: @questions.to_json(include: %i[ answers ])

    render json: @questions, each_serializer: QuestionsSerializer

    # render json: @questions, serializer: <имя класса сериалайзера> для объекта
    # render json: @questions, each_serializer: <имя класса сериалайзера> для коллекции
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    
    if @question.save
      render json: @question, serializer: QuestionSerializer, status: :created
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    return unless current_resource_owner.author?(@question)

    if @question.update(question_params)
      render json: @question, serializer: QuestionSerializer
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    return unless current_resource_owner.author?(@question)

    if @question.destroy
      render json: { message: 'Question deleted' }
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
