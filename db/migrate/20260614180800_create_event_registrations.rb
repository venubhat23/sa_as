class CreateEventRegistrations < ActiveRecord::Migration[8.0]
  def change
    create_table :event_registrations do |t|
      t.bigint :event_id
      t.bigint :member_id
      t.date :registration_date
      t.string :payment_status, default: "pending"
      t.string :attendance_status, default: "registered"

      t.timestamps
    end
  end
end
