class Theme < ApplicationRecord
  belongs_to :user

  has_many :links, dependent: :destroy
  # has_many :one_links, dependent: :destroy

  has_many :favorites, dependent: :destroy

  include Hashid::Rails

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
