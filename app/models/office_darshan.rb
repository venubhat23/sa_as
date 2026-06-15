class OfficeDarshan < ApplicationRecord
  belongs_to :host_member, class_name: "Member", optional: true
  has_many :office_darshan_visitors, dependent: :destroy
end
