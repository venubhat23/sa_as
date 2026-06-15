class Event < ApplicationRecord
  has_many :event_registrations, dependent: :destroy
  validates :title, presence: true
end
