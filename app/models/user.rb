
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  # <<バリデーション>>
  validates :nickname, presence: true, uniqueness: { case_sensitive: true }
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d_-]+\z/i.freeze

  validates :birth_date, presence: true

  # パスワードの英数字混在を否定
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX, message: 'Include both letters and numbers'

  # 全角のひらがなor漢字を使用していないか検証
  with_options presence: true, format: { with: /\A[ぁ-んァ-ン一-龥]+\z/, message: 'Full-width characters' } do
    validates :first_name
    validates :last_name
  end

  # 全角のカタカナを使用していないか検証
  with_options presence: true, format: { with: /\A[\p{katakana}　ー－&&[^ -~｡-ﾟ]]+\z/, message: 'Full-width katakana characters' } do
    validates :first_name_kana
    validates :last_name_kana
  end

  # <<アソシエーション>>
  has_many :items
  has_many :item_transactions
  has_one :card, dependent: :destroy
  has_one :address_preset, dependent: :destroy
  # 追加
  has_many :sns_credential


  # 最終的にuserのインスタンスを返すクラスメソッド
  # SNSと同emailのユーザが存在すればそのユーザを返す。いなければuserを作成し返す。
  def self.from_sns_credential(sns, auth)
    # snsの情報が既にDBにあった場合は、2回目以降のログインなので紐づくuserを返す
    return sns.user if sns.persisted?
    # snsの情報がDBにない場合
    # 既存ユーザへSNSサービス連携or新規ユーザ登録
    user = User.where(email: auth.info.email).first_or_initialize
    if user.persisted?
      user.sns_credentials << sns
      user.save
    else
      user.nickname = auth.info.name
    end
    user
  end
end