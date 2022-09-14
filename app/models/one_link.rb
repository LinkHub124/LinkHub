class OneLink < ApplicationRecord
  # belongs_to :user
  # belongs_to :theme_id
  belongs_to :link, optional: true
  acts_as_list scope: :link

  validates :url, presence: true

  validates :rate, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true
end
