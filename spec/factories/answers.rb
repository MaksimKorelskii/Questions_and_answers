FactoryBot.define do
  factory :answer do
    body { "Answer Text" }

    trait :invalid do
      body {nil}
    end
  end
end
