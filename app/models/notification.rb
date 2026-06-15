class Notification < ApplicationRecord
  belongs_to :user, optional: true
  scope :unread, -> { where(is_read: false) }
end
