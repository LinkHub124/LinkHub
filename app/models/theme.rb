class Theme < ApplicationRecord
  enum status: { draft: 0, limited: 1, release: 2 }
  belongs_to :user

  has_many :links, dependent: :destroy
  # has_many :one_links, dependent: :destroy

  include Hashid::Rails
end
