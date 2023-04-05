class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :github, :vkontakte ]

  has_many :awards, dependent: :destroy
  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :rates
  has_many :authorizations, dependent: :destroy

  def admin!
    update!(admin: true)
  end

  # использование делегирования метода в сервис, чтобы не переписывать контроллер и тесты
  def self.find_for_oauth(auth_data)
    FindForOauthService.new(auth_data).call
  end

  def author?(resource)
    id == resource.author_id
  end
end
