class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:twitter, :google_oauth2],
                        authentication_keys: [:login]

  # Association
  has_many :themes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_themes, through: :favorites, source: :theme
  has_many :relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # Validation
  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: true, format: { with: /\A[0-9a-zA-Z]+\z/ }, invalid_words: true
  validates :introduction, length: { maximum: 200 }
  validates_acceptance_of :agreement, allow_nil: false, on: :create

  attachment :profile_image
  attr_writer :login

  # Description: nameにwordを含むユーザーを返す.
  def self.looks(word)
    User.where('name LIKE?', "%#{word}%")
  end

  # Description: フォローしたときの処理.
  def follow(user_name)
    user = User.find_by(name: user_name)
    relationships.create(followed_id: user.id)
  end

  # Description: フォローを外すときの処理.
  def unfollow(user_name)
    user = User.find_by(name: user_name)
    relationships.find_by(followed_id: user.id).destroy
  end

  # Description: フォローしているか判定.
  def following?(user)
    followings.include?(user)
  end

  # Description: 退会済みのユーザーの場合、ログインやパスワードの再設定ができないように.
  def active_for_authentication?
    super && (is_deleted == false) # 退会済みの場合、falseを返す.
  end

  # Description: 退会済み用のメッセージを表示させる.
  def inactive_message
    is_deleted == false ? super : :account_withdrawal # active_for_authentication?がfalseの時に呼び出される.
  end

  # Description: DeviseControllerからのオーバーライド、渡ってきたloginを処理.
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      # nameがloginと一致、またはemailがloginと一致.
      where(conditions.to_h).where(['name = :value OR email = :value', { value: login }]).first
    elsif conditions.key?(:name) || conditions.key?(:email)
      # loginではなくname、emailで送られてきた場合.
      where(conditions.to_h).first
    end
  end

  # Description: OAuth認証ログイン用、ユーザーの情報があれば探し、無ければ作成する.
  def self.find_for_oauth(auth)
    user = User.find_by(uid: auth.uid, provider: auth.provider)
    case auth.provider
    when 'google_oauth2'
      user ||= User.new(
        uid: auth.uid,
        provider: auth.provider,
        name: auth.info.email.match(/[a-z\d]+/),
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        agreement: true
      )
    end
    user
  end
end
