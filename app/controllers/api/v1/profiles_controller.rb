class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!
  
  def me
    # head :ok
    # render json: current_user # это метод devise, а в api контроллеры защищены doorkeeper и у него нет метода current_user и нет сессии через которую работает devise 
    render json: current_resource_owner
  end

private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end