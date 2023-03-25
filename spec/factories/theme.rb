FactoryBot.define do
  factory :theme do
    title { Faker::Lorem.characters(number: 10) }
    post_status { Faker::Number.between(from: 0, to: 2) }
    user
  end
end
