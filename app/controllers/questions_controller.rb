class QuestionsController < ApplicationController
  include Rated
  
  before_action :authenticate_user!, except: %i[ show index ]
  before_action :set_question, only: %i[ show update destroy ]

  after_action :publish_question, only: :create

  authorize_resource # метод CanCan, который для каждого экшна выполняет authorize! с нужными аргументами и параметрами.
  # load_and_authorize_resource

  def index
    # authorize! :index, Question # второй параметр это коллекция класса Question. когда вызывается authorize создаётся класс Ability, ему передаётся user = current_user и выполняется can с соответствующей ролью (read - show and index)
    # authorize! :read, Question
    @questions = Question.all
  end

  def new
    # authorize! :create, Question
    @question = Question.new
    @question.links.new # .build
    @question.build_award
  end

  def show
    # authorize! :read, @question
    gon.question_id = @question.id
    @answer = @question.answers.new
    @answers = @question.answers.sort_by_best
    @answer.links.new # .build 
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
    # authorize! :destroy, Question
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
                                    links_attributes: [ :name, :url ],
                                    award_attributes: [ :name, :link ],
                                    files: [])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions_channel',
                                 html:
                                  ApplicationController.render(
                                    partial: 'questions/question_index',
                                    locals: { question: @question }
                                  ),
                                 author_id: current_user.id)
  end
end
