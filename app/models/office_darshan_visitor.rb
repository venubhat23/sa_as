class OfficeDarshanVisitor < ApplicationRecord
  belongs_to :office_darshan, optional: true
  belongs_to :member, optional: true
end
