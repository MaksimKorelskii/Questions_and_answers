class Api::V1::ProfilesController < Api::V1::BaseController
  
  def me
    # head :ok
    # render json: current_user # это метод devise, а в api контроллеры защищены doorkeeper и у него нет метода current_user и нет сессии через которую работает devise 
    render json: current_resource_owner
  end

  def index
    @users = User.where.not(id: current_resource_owner.id)
    render json: @users    
  end
end
