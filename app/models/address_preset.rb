class AddressPreset < ApplicationRecord

  belongs_to :user

  with_options presence: true do
    validates :postal_code, format: { with: /\A\d{3}[-]\d{4}\z/, message: 'Input correctly' }
    validates :prefecture, numericality: { other_than: 0, message: 'Select' }
    validates :city
    validates :addresses
    validates :phone_number
  end

end