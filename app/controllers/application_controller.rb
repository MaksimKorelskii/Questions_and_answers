class ApplicationController < ActionController::Base
  before_action :gon_current_user

  rescue_from CanCan::AccessDenied do |e|
    respond_to do |format|
      format.html { redirect_to root_path, alert: e.message }
      format.json { render json: { error: 'Not authorized' }, status: :forbidden }
      format.js   { render json: { error: 'Not authorized' }, status: :forbidden }
    end
  end

  private

  def gon_current_user
    gon.current_user_id = current_user.id if user_signed_in?
  end
end
