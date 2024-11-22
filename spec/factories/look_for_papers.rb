FactoryBot.define do
  factory :look_for_paper do
    association :user
    look_for_paper { Faker::Lorem.sentence }
    journal        { Faker::Lorem.word }
    search_word    { Faker::Lorem.word }
  end
end
