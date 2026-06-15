class CreateMeetingAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :meeting_attendances do |t|
      t.bigint :weekly_meeting_id
      t.bigint :member_id
      t.integer :attendance_status, default: 0
      t.datetime :check_in_time
      t.string :method

      t.timestamps
    end
  end
end
