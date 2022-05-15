class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :themes, dependent: :destroy
  has_many :links, dependent: :destroy
  # has_many :one_links, dependent: :destroy

  has_many :favorites, dependent: :destroy

  def self.looks(word)
    user = User.where("name LIKE?","%#{word}%")
    user
  end

end
