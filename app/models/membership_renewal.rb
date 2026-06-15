class MembershipRenewal < ApplicationRecord
  belongs_to :member, optional: true
  belongs_to :plan, class_name: "MembershipPlan", optional: true
  has_many :fee_collections, foreign_key: :renewal_id, dependent: :nullify
end
