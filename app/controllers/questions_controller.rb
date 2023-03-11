class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[ show index ]
  before_action :set_question, only: %i[ show update destroy ]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.links.new # .build 
  end

  def show
    @answer = @question.answers.new
    @answers = @question.answers.sort_by_best
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Question was created successfully'
    else
      render :new
    end
  end

  def update
    if current_user.author?(@question)
      @question.update(question_params)
      flash[:notice] = 'Your question has been successfully edited.'
    else
      flash[:alert] = "You can't edited another's question."
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
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                    links_attributes: [ :name, :url ], files: [])
  end
end
