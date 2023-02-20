class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[ show ]
  before_action :set_question, only: %i[ new create  ]

  # def new
  #   @answer = @question.answers.new
  # end

  # def show
  # end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer has been successfully deleted.'
    else
      flash[:alert] = "You can't delete another's answer."
    end
    
    redirect_to @answer.question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
