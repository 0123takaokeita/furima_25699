class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  # <<バリデーション>>

  # 値が入っているか検証
  with_options presence: true do
    validates :images  ## imageをimagesに変更
    validates :name
    validates :info
    validates :price
  end

  # 金額が半角であるか検証
  validates :price, numericality: { with: /\A[0-9]+\z/, message: 'Half-width number' }

  # 金額の範囲
  validates_inclusion_of :price, in: 300..9_999_999, message: 'Out of setting range'

  # 選択関係で「---」のままになっていないか検証
  with_options numericality: { other_than: 0, message: 'Select' } do
    validates :category_id
    validates :sales_status_id
    validates :shipping_fee_status_id
    validates :prefecture_id
    validates :scheduled_delivery_id
  end

  # <<アクティブハッシュの設定関連>>
  belongs_to_active_hash :category
  belongs_to_active_hash :sales_status
  belongs_to_active_hash :shipping_fee_status
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :scheduled_delivery

  # <<アクティブストレージの設定関連>>
  has_many_attached :images #複数枚投稿
  validates :images, length: { minimum: 1, maximum: 5, message: "は1枚以上5枚以下にしてください" }

  # <<アソシエーション>>
  belongs_to :user
  has_one :item_transaction
  has_many :comments
end
