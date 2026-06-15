class CreateWeeklyMeetings < ActiveRecord::Migration[8.0]
  def change
    create_table :weekly_meetings do |t|
      t.bigint :chapter_id
      t.date :meeting_date
      t.string :meeting_type
      t.string :venue
      t.text :agenda
      t.string :status, default: "scheduled"
      t.text :notes

      t.timestamps
    end
  end
end
