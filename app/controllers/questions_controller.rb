class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[ show index ]
  before_action :set_question, only: %i[ show destroy ]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
    @answer = @question.answers.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Question was created successfully'
    else
      render :new
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      flash[:notice] = 'Your question has been successfully deleted.'
    else
      flash[:alert] = "You can't delete another's question."
    end
    
    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
