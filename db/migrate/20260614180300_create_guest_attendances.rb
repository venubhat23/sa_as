class CreateGuestAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :guest_attendances do |t|
      t.bigint :weekly_meeting_id
      t.bigint :guest_id
      t.string :attendance_status, default: "present"
      t.datetime :check_in_time

      t.timestamps
    end
  end
end
