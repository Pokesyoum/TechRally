FactoryBot.define do
  factory :paper_stock do
    association :user
    outline   { Faker::Lorem.sentence }
    paper_url { Faker::Lorem.sentence }
  end
end
