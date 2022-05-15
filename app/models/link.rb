class Link < ApplicationRecord
  belongs_to :user
  belongs_to :theme

  has_many :one_links, dependent: :destroy

  accepts_nested_attributes_for :one_links, allow_destroy: true # この行を追記

  def self.looks(word)
    link  = Link.where("subtitle LIKE?","%#{word}%")
    link += Link.where("caption LIKE?","%#{word}%")
    link
  end

end
