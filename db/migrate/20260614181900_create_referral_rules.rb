class CreateReferralRules < ActiveRecord::Migration[8.0]
  def change
    create_table :referral_rules do |t|
      t.string :rule_type
      t.string :value
      t.text :description
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
