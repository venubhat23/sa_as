class CreateAttendanceRules < ActiveRecord::Migration[8.0]
  def change
    create_table :attendance_rules do |t|
      t.string :rule_type
      t.string :value
      t.text :description
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
