FactoryBot.define do
  factory :rally do
    association :user
    title      { Faker::Lorem.sentence }
    abstract   { Faker::Lorem.paragraph }
    background { Faker::Lorem.paragraph }
    idea       { Faker::Lorem.paragraph }
    exp_method { Faker::Lorem.paragraph }
    result     { Faker::Lorem.paragraph }
    discussion { Faker::Lorem.paragraph }
    conclusion { Faker::Lorem.paragraph }
    opinion    { Faker::Lorem.paragraph }
    URL        { Faker::Lorem.sentence }
    draft      { [true, false].sample }
  end
end
