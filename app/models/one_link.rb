class OneLink < ApplicationRecord
  # Association
  belongs_to :link, optional: true # one_linkから先に作成されるからoptional: trueでないとエラーが発生する？要検証.
  acts_as_list scope: :link

  # Validation
  validates :url, presence: true
  validates :rate, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true
end
