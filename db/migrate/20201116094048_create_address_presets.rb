class CreateAddressPresets < ActiveRecord::Migration[6.0]
  def change
    create_table :address_presets do |t|
      t.string :postal_code, null: false
      t.integer :prefecture, null: false
      t.string :city, null: false
      t.string :addresses, null: false
      t.string :building
      t.string :phone_number
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end