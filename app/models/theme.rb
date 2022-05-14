class Theme < ApplicationRecord
  belongs_to :user

  include Hashid::Rails
end
