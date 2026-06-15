class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :event_type
      t.datetime :start_date
      t.datetime :end_date
      t.string :venue
      t.text :description
      t.integer :capacity
      t.decimal :registration_fee, precision: 12, scale: 2
      t.string :status, default: "upcoming"

      t.timestamps
    end
  end
end
