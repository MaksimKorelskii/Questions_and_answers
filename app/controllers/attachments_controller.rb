class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    if current_user.author?(@attachment.record)
      @attachment.purge
      flash[:notice] = 'Attachment was successfully deleted.'
    else
      flash[:alert] = "You can't delete another's attachment!"
    end
  end
end
