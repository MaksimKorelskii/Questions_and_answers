FactoryBot.define do
  factory :question do
    title { "Question Title" }
    body { "Question Text" }
  end

  trait :invalid do
    title {nil}
    body {nil}
  end
end
