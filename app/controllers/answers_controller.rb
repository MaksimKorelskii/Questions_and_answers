class AnswersController < ApplicationController
  include Rated

  before_action :authenticate_user!, except: %i[ show ]
  before_action :set_question, only: %i[ new create show ]
  before_action :set_answer, only: %i[ update destroy mark_as_best ]

  after_action :publish_answer, only: :create

  authorize_resource

  def new
    @answer = @question.answers.new
  end

  def show
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.author = current_user
    @answer.save
    flash[:notice] = 'Your answer has been successfully created.' if @answer.save
  end

  def update
    if current_user.author?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
      @answers = @question.answers.sort_by_best
      flash[:notice] = 'Your answer has been successfully edited.'
    else
      flash[:alert] = "You can't edited another's answer."
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      @question = @answer.question
      @answers = @question.answers.sort_by_best
      flash[:notice] = 'Your answer has been successfully deleted.'
    else
      flash[:alert] = "You can't delete another's answer."
    end
  end

  def mark_as_best
    if current_user.author?(@answer.question)
      @answer.mark_as_best
      @question = @answer.question
      @answers = @answer.question.answers.sort_by_best
      flash[:notice] = "Best answer was chosen successfully!"
    else
      flash[:alert] = "You can't select the answer as best as a non-author!"
    end
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [ :name, :url ], files: [])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast "question_channel_#{@answer.question.id}",
                                 html: ApplicationController.render(partial: 'answers/answer_ws',
                                 locals: { answer: @answer }),
                                 author_id: current_user.id
  end
end
