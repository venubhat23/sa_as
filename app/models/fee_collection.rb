class FeeCollection < ApplicationRecord
  belongs_to :member, optional: true
  belongs_to :renewal, class_name: "MembershipRenewal", optional: true
end
