class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         # Twitter API認証用に追加
         :omniauthable, omniauth_providers: [:twitter]


  attachment :profile_image # ここを追加（_idは含めません）

  has_many :themes, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :favorited_themes, through: :favorites, source: :theme
  # has_many :one_links, dependent: :destroy

  has_many :favorites, dependent: :destroy


  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: true, format:{ with: /\A[0-9a-zA-Z]+\z/ }
  validates :name, invalid_words: true
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

  # Twitter認証ログイン用
  # ユーザーの情報があれば探し、無ければ作成する
  def self.find_for_oauth(auth)
    user = User.find_by(uid: auth.uid, provider: auth.provider)

    user ||= User.create(
      uid: auth.uid,
      provider: auth.provider,
      #name: auth[:info][:name],
      name: auth["extra"]["access_token"].params[:screen_name],
      email: User.dummy_email(auth),
      #password: Devise.friendly_token[0, 20]
      password: 123456
    )
    user
  end

  # ダミーのメールアドレスを作成
  def self.dummy_email(auth)
    "#{Time.now.strftime('%Y%m%d%H%M%S').to_i}-#{auth.uid}-#{auth.provider}@example.com"
  end

end
