class CreateScheduledDeliveries < ActiveRecord::Migration[6.0]
  def change
    create_table :scheduled_deliveries do |t|

      t.timestamps
    end
  end
end
