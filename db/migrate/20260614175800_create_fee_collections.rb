class CreateFeeCollections < ActiveRecord::Migration[8.0]
  def change
    create_table :fee_collections do |t|
      t.bigint :member_id
      t.bigint :renewal_id
      t.decimal :amount, precision: 12, scale: 2
      t.string :payment_mode
      t.date :payment_date
      t.string :receipt_number
      t.text :notes
      t.string :status, default: "completed"

      t.timestamps
    end
  end
end
