class OneLink < ApplicationRecord
  # belongs_to :user
  # belongs_to :theme_id
  belongs_to :link

  validates :url, presence: true

end
