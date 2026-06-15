class CreateOfficeDarshans < ActiveRecord::Migration[8.0]
  def change
    create_table :office_darshans do |t|
      t.bigint :host_member_id
      t.date :visit_date
      t.text :purpose
      t.text :feedback
      t.string :status, default: "scheduled"

      t.timestamps
    end
  end
end
