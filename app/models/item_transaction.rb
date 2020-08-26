class ItemTransaction < ApplicationRecord
  # <<アソシエーション>>
  belongs_to :user
  belongs_to :item
end