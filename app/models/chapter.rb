class Chapter < ApplicationRecord
  belongs_to :forum, optional: true
  has_many :members, dependent: :nullify
  has_many :guests, dependent: :nullify
  has_many :weekly_meetings, dependent: :destroy
  has_many :committee_assignments, dependent: :nullify
  validates :name, presence: true
  scope :active, -> { where(status: "active") }
end
