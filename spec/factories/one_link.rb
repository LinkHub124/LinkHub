FactoryBot.define do
  factory :one_link do
    url { Faker::Lorem.characters(number: 30) }
    rate { Faker::Number.between(from: 1, to: 5) }
    link
  end
end
