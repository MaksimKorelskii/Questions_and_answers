class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    # render json: request.env['omniauth.auth']
    sign_in_on_callback('Github')
  end

  def vkontakte
    # render json: request.env['omniauth.auth']
    sign_in_on_callback('Vkontakte')
  end

  private

  def sign_in_on_callback(provider)
    # находит пользователя по данным от провайдера
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
