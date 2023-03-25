class CommentsController < ApplicationController
  before_action :set_context, :authenticate_user!, only: :create

  after_action :publish_comment, only: :create

  def create
    @comment = @context.comments.create(comment_params.merge(user: current_user))
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast "comments_channel_#{params[:question_id] || @comment.commentable.question.id}",
      { html: ApplicationController.render(partial: 'comments/comment',
                                          locals: { comment: @comment }),
        commentable_type: @comment.commentable_type.downcase,
        commentable_id: @comment.commentable_id,
        author_id: current_user.id }
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_context
    @context = context_klass.find(context_id)
  end

  def context_klass
    params[:context].constantize
  end

  def context_id
    params["#{context_klass.to_s.downcase}_id".to_sym]
  end
end
