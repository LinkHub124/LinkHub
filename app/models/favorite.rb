class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :theme

  validates_uniqueness_of :theme_id, scope: :user_id
end
