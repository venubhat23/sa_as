class AttendanceRule < ApplicationRecord
  scope :active, -> { where(status: "active") }
end
