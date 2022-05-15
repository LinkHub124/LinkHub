class Theme < ApplicationRecord
  belongs_to :user

  has_many :links, dependent: :destroy
  # has_many :one_links, dependent: :destroy

  include Hashid::Rails
end
