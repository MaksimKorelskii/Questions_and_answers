class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[ show ]
  before_action :set_question, only: %i[ new create ]
  before_action :set_answer, only: %i[ update destroy ]

  def new
    @answer = @question.answers.new
  end

  def show
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer has been successfully deleted.'
    else
      flash[:alert] = "You can't delete another's answer."
    end
    
    redirect_to @answer.question
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
