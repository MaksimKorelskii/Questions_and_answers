FactoryBot.define do
  factory :answer do
    body { "Answer Text" }

    trait :invalid do
      body {nil}
    end

    trait :with_file do
      after :create do |answer|
        answer.files.attach(
          io:           File.open(Rails.root.join('spec', 'rails_helper.rb')),
          filename:     'rails_helper.rb',
          content_type: 'text/rb'
        )
      end
    end
  end
end
