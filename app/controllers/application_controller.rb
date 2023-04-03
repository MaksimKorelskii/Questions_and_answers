class ApplicationController < ActionController::Base
  before_action :gon_current_user

  rescue_from CanCan::AccessDenied do |e|
    redirect_to root_path, alert: e.message
  end

  # check_authorization

  private

  def gon_current_user
    gon.current_user_id = current_user.id if user_signed_in?
  end
end
