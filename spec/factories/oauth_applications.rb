FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name         { 'TestApp' }
    uid          { '1111111111' }
    secret       { '4444444444' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
  end
end
