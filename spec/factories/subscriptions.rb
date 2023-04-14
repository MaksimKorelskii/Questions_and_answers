FactoryBot.define do
  factory :subscription do
    association :subscriber, factory: :user
    question
  end
end
