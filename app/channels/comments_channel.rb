class CommentsChannel < ApplicationCable::Channel

  def subscribed
    stream_from "comments_channel_#{params[:question_id]}"
  end
end
