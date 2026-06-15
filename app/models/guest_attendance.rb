class GuestAttendance < ApplicationRecord
  belongs_to :weekly_meeting, optional: true
  belongs_to :guest, optional: true
end
