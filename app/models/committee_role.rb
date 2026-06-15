class CommitteeRole < ApplicationRecord
  has_many :committee_assignments, dependent: :nullify
  validates :name, presence: true
  scope :active, -> { where(status: "active") }
end
