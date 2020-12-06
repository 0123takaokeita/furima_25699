class CreateCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cards do |t|
      t.string :card_token, null: false  ## null: false追加
      t.string :customer_token, null: false ## null: false追加
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end