class CommitteeAssignment < ApplicationRecord
  belongs_to :member, optional: true
  belongs_to :committee_role, optional: true
  belongs_to :chapter, optional: true
end
