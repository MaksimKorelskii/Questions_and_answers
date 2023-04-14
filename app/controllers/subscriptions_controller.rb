class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @subscription = @question.subscriptions.create(subscriber: current_user)

    render :subscription
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @question = @subscription.question
    @subscription.destroy

    render :subscription
  end
end
