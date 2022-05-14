class Link < ApplicationRecord
  # belongs_to :user
  belongs_to :theme

  # has_many :one_links, dependent: :destroy
end
