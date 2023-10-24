FactoryBot.define do
  factory :relationship do
    follower { create(:user) }
    followed { create(:user) }
  end
end
