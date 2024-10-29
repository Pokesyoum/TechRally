FactoryBot.define do
  factory :user_mission do
    association :user
    association :mission
    completed   { [true, false].sample }
  end
end
