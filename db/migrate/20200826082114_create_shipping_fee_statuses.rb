class CreateShippingFeeStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :shipping_fee_statuses do |t|

      t.timestamps
    end
  end
end
