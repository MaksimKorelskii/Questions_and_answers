class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[ show index ]
  before_action :set_question, only: %i[ show ]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Question was created successfully'
    else
      render :new
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
