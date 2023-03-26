FactoryBot.define do
  factory :link do
    subtitle { Faker::Lorem.characters(number: 30) }
    caption { Faker::Lorem.characters(number: 300) }
    theme
  end
end
