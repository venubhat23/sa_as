class Guest < ApplicationRecord
  belongs_to :business_category, optional: true
  belongs_to :chapter, optional: true
  belongs_to :invited_by_member, class_name: "Member", optional: true
  belongs_to :converted_member, class_name: "Member", optional: true
  has_many :guest_attendances, dependent: :destroy

  enum :lifecycle_status, { invited: 0, registered: 1, attended: 2, follow_up: 3, converted: 4 }, prefix: true

  validates :name, presence: true
end
