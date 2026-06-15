class Referral < ApplicationRecord
  belongs_to :given_by_member, class_name: "Member", optional: true
  belongs_to :given_to_member, class_name: "Member", optional: true
  has_many :thank_you_slips, dependent: :nullify

  enum :workflow_status, {
    new_referral: 0, contacted: 1, qualified: 2,
    proposal_submitted: 3, won: 4, lost: 5
  }, prefix: true
end
