class MeetingAttendance < ApplicationRecord
  belongs_to :weekly_meeting, optional: true
  belongs_to :member, optional: true

  enum :attendance_status, { present: 0, absent: 1, late: 2, substitute: 3, excused: 4 }, prefix: true
end
