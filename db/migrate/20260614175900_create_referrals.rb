class CreateReferrals < ActiveRecord::Migration[8.0]
  def change
    create_table :referrals do |t|
      t.string :referral_number
      t.date :referral_date
      t.bigint :given_by_member_id
      t.bigint :given_to_member_id
      t.string :client_name
      t.string :client_phone
      t.decimal :referral_value, precision: 12, scale: 2
      t.text :notes
      t.integer :workflow_status, default: 0

      t.timestamps
    end
  end
end
