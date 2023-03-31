class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization.present?

    user = find_user_by_email || create_new_user

    user.authorizations.create!(provider: auth.provider, uid: auth.uid.to_s)
    user
  end

  private

  def find_user_by_email
    User.find_by(email: auth.info[:email])
  end

  def create_new_user
    email = auth.info[:email]
    password = Devise.friendly_token[0, 20]
    User.create!(email: email,
                 password: password,
                 password_confirmation: password)
  end
end
