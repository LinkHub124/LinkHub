class Theme < ApplicationRecord
  include Hashid::Rails

  # Association
  belongs_to :user
  has_many :links, dependent: :destroy
  has_many :favorites, dependent: :destroy
  acts_as_taggable_on :tags

  # Validation
  validates :title, presence: true, length: { maximum: 50 }
  validates :tags, length: { maximum: 10 } # 10文字以内.
  validates :tag_list, length: { maximum: 5 } # 5個以内.

  # Description: このテーマがuserにいいねされているかどうか.
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # Description: titleにwordを含むテーマを返す
  def self.looks(word)
    theme = Theme.where('title LIKE?', "%#{word}%")
    theme.reverse
  end
end
