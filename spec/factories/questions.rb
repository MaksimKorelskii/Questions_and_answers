FactoryBot.define do
  factory :question do
    title { "Question Title" }
    body { "Question Text" }
  end

  trait :invalid do
    title {nil}
    body {nil}
  end

  trait :with_file do
    after :create do |question|
      question.files.attach(
        io:           File.open(Rails.root.join('spec', 'rails_helper.rb')),
        filename:     'rails_helper.rb',
        content_type: 'text/rb'
      )
    end
  end
end
