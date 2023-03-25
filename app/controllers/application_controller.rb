class ApplicationController < ActionController::Base
  before_action :gon_current_user

  private

  def gon_current_user
    gon.current_user_id = current_user.id if user_signed_in?
  end
end
