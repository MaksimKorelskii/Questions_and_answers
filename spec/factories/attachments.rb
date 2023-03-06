FactoryBot.define do
  factory :attachment, class: 'ActiveStorage::Attachment' do
    name { 'files' }
  end
end
