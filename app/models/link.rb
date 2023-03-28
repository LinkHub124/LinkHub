class Link < ApplicationRecord
  belongs_to :user
  belongs_to :theme

  has_many :one_links, -> { order(position: :asc) }, dependent: :destroy

  validates :subtitle, presence: true, length: { maximum: 50 }
  validates :caption, length: { maximum: 500 }

  accepts_nested_attributes_for :one_links, allow_destroy: true # この行を追記

  include Hashid::Rails
  def self.looks(word)
    link  = Link.where('caption LIKE?', "%#{word}%")
    link += Link.where('subtitle LIKE?', "%#{word}%")
    link.reverse
  end
end
