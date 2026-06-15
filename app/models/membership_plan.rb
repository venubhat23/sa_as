class MembershipPlan < ApplicationRecord
  has_many :members, dependent: :nullify
  has_many :membership_renewals, foreign_key: :plan_id, dependent: :nullify
  validates :name, presence: true
  scope :active, -> { where(status: "active") }
end
