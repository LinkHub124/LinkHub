class OneLink < ApplicationRecord
  # belongs_to :user
  # belongs_to :theme_id
  belongs_to :link, optional: true
  acts_as_list scope: :link

  validates :url, presence: true

end
