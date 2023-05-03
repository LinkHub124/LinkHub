class Link < ApplicationRecord
  include Hashid::Rails

  # Association
  belongs_to :theme
  has_many :one_links, -> { order(position: :asc) }, dependent: :destroy
  accepts_nested_attributes_for :one_links, allow_destroy: true

  # Validation
  validates :subtitle, presence: true, length: { maximum: 50 }
  validates :caption, length: { maximum: 500 }

  # Description: captionかsubtitleにwordを含むリンク集を返す.
  def self.looks(word)
    link  = Link.where('caption LIKE?', "%#{word}%")
    link += Link.where('subtitle LIKE?', "%#{word}%")
    link.reverse
  end
end
