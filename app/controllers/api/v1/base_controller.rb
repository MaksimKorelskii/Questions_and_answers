class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  protect_from_forgery with: :null_session
  # protect_from_forgery prepend: true

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_user
    current_resource_owner
  end
end
