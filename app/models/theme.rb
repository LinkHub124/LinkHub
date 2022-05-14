class Theme < ApplicationRecord
  belongs_to :user

  has_many :links, dependent: :destroy
  # has_many :one_links, dependent: :destroy

  accepts_nested_attributes_for :links, allow_destroy: true # この行を追記

  include Hashid::Rails
end
