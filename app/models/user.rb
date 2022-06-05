class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable


  attachment :profile_image # ここを追加（_idは含めません）

  has_many :themes, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :favorited_themes, through: :favorites, source: :theme
  # has_many :one_links, dependent: :destroy

  has_many :favorites, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: true, format:{ with: /\A[0-9a-zA-Z]+\z/ }
  # VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
  # validates :password, format: { with: VALID_PASSWORD_REGEX, message: 'は半角英数を両方含む必要があります' }


  def self.looks(word)
    user = User.where("name LIKE?","%#{word}%")
    user
  end

  # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  def active_for_authentication?
    super && (is_deleted == false)
  end

  # フォローしたときの処理
  def follow(user_name)
    user = User.find_by(name: user_name)
    relationships.create(followed_id: user.id)
  end
  # フォローを外すときの処理
  def unfollow(user_name)
    user = User.find_by(name: user_name)
    relationships.find_by(followed_id: user.id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

end
