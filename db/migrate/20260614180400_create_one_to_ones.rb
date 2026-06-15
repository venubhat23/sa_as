class CreateOneToOnes < ActiveRecord::Migration[8.0]
  def change
    create_table :one_to_ones do |t|
      t.bigint :member1_id
      t.bigint :member2_id
      t.date :meeting_date
      t.string :location
      t.text :agenda
      t.text :discussion_notes
      t.text :action_items
      t.string :status, default: "scheduled"

      t.timestamps
    end
  end
end
