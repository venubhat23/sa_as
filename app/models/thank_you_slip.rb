class ThankYouSlip < ApplicationRecord
  belongs_to :referral, optional: true
  belongs_to :received_by_member, class_name: "Member", optional: true
  belongs_to :thanked_to_member, class_name: "Member", optional: true
end
