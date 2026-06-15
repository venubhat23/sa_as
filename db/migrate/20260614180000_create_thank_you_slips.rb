class CreateThankYouSlips < ActiveRecord::Migration[8.0]
  def change
    create_table :thank_you_slips do |t|
      t.bigint :referral_id
      t.decimal :business_value, precision: 12, scale: 2
      t.string :invoice_number
      t.string :client_name
      t.bigint :received_by_member_id
      t.bigint :thanked_to_member_id
      t.date :date
      t.text :notes

      t.timestamps
    end
  end
end
