class Card < ApplicationRecord
  belongs_to :user
  ## 追加
  validates :card_token, :customer_token, presence: true
end