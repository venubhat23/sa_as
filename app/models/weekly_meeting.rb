class WeeklyMeeting < ApplicationRecord
  belongs_to :chapter, optional: true
  has_many :meeting_attendances, dependent: :destroy
  has_many :guest_attendances, dependent: :destroy
end
