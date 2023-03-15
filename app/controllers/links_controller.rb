class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    @link = Link.find(params[:id])

    if current_user.author?(@link.linkable)
      @link.destroy
      flash[:notice] = 'Your link has been successfully deleted.'
    else
      flash[:alert] = "You can't delete another's link."
    end
  end
end
