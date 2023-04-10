class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: %i[ show update destroy ]
  before_action :set_question, only: %i[ index create ]

  def index
    @answers = @question.answers
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.author = current_resource_owner

    if @answer.save
      render json: @answer, serializer: AnswerSerializer, status: :created
    elsif 
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    return unless current_resource_owner.author?(@answer)

    if @answer.update(answer_params)
      render json: @answer, serializer: AnswerSerializer, status: :created
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    return unless current_resource_owner.author?(@answer)

    if @answer.destroy
      render json: { message: 'Answer deleted' }
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
