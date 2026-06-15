class CreateMembershipRenewals < ActiveRecord::Migration[8.0]
  def change
    create_table :membership_renewals do |t|
      t.bigint :member_id
      t.bigint :plan_id
      t.date :renewal_date
      t.date :expiry_date
      t.decimal :amount, precision: 12, scale: 2
      t.string :payment_status, default: "pending"
      t.text :notes

      t.timestamps
    end
  end
end
