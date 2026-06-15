class CreateCommitteeAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :committee_assignments do |t|
      t.bigint :member_id
      t.bigint :committee_role_id
      t.bigint :chapter_id
      t.date :start_date
      t.date :end_date
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
