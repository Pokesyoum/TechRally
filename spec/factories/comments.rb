FactoryBot.define do
  factory :comment do
    association :user
    association :rally
    content     { Faker::Lorem.sentence }
  end
end
