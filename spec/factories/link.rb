FactoryBot.define do
  factory :link do
    subtitle { Faker::Lorem.characters(number: 30) }
    captions { Faker::Lorem.characters(number: 300) }
    user
    theme
  end
end
