class Theme < ApplicationRecord
  MAX_LINKS_COUNT = 10
  belongs_to :user

  has_many :links, dependent: :destroy
  validates_associated :links, message: "cannot have more than #{MAX_LINKS_COUNT} links"
  validate :validate_links_count

  has_one  :theme_rank
  # has_many :one_links, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user


  validates :title, presence: true, length: { maximum: 50 }
  validates :post_status, presence: true, inclusion: { in: 0..2 }



  acts_as_taggable_on :tags
  validates :tags, :length => { maximum: 10 } #10文字以内

  # validates :tag_list, :length => { maximum: 5 } #5個以内
  validate :validate_tag_list_count



  include Hashid::Rails

  def validate_links_count
    errors.add(:links, "cannot have more than #{MAX_LINKS_COUNT} links") if self.links.count > MAX_LINKS_COUNT
  end

  def validate_tag_list_count
    if tag_list.size > 5
      errors.add(:tag_list, 'cannot have more than 10 tags')
    end
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(word)
    theme = Theme.where("title LIKE?","%#{word}%")
    theme = theme.reverse
    theme
  end

end
