class CreateMembershipPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :membership_plans do |t|
      t.string :name
      t.integer :duration_months
      t.decimal :fee_amount, precision: 12, scale: 2
      t.text :description
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
