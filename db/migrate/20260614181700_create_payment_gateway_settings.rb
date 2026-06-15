class CreatePaymentGatewaySettings < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_gateway_settings do |t|
      t.string :gateway_name
      t.string :api_key
      t.string :api_secret
      t.boolean :is_active, default: false
      t.string :environment, default: "test"

      t.timestamps
    end
  end
end
