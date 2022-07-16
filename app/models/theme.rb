class Theme < ApplicationRecord
  belongs_to :user

  has_many :links, dependent: :destroy
  has_one  :theme_rank
  # has_many :one_links, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  
  # has_many :post_tags, dependent: :destroy
  # has_many :tags, through: :post_tags, source: :tag

  validates :title, presence: true, length: { maximum: 50 }

  include Hashid::Rails

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(word)
    theme = Theme.where("title LIKE?","%#{word}%")
    theme = theme.reverse
    theme
  end

end
