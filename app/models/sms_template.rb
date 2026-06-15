class SmsTemplate < ApplicationRecord
  validates :name, presence: true
  scope :active, -> { where(status: "active") }
end
