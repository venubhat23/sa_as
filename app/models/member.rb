class Member < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :chapter, optional: true
  belongs_to :forum, optional: true
  belongs_to :business_category, optional: true
  belongs_to :business_specialty, optional: true
  belongs_to :membership_plan, optional: true

  has_many :referrals_given, class_name: "Referral", foreign_key: :given_by_member_id, dependent: :nullify
  has_many :referrals_received, class_name: "Referral", foreign_key: :given_to_member_id, dependent: :nullify
  has_many :meeting_attendances, dependent: :destroy
  has_many :membership_renewals, dependent: :nullify
  has_many :fee_collections, dependent: :nullify
  has_many :event_registrations, dependent: :nullify
  has_many :committee_assignments, dependent: :nullify
  has_many :one_to_ones_as_member1, class_name: "OneToOne", foreign_key: :member1_id, dependent: :nullify
  has_many :one_to_ones_as_member2, class_name: "OneToOne", foreign_key: :member2_id, dependent: :nullify

  enum :membership_status, { active: 0, expired: 1, suspended: 2, pending: 3 }, prefix: true

  validates :first_name, presence: true

  scope :active, -> { where(membership_status: :active) }
  scope :by_chapter, ->(id) { where(chapter_id: id) if id.present? }
  scope :by_category, ->(id) { where(business_category_id: id) if id.present? }
  scope :by_status, ->(s) { where(membership_status: s) if s.present? }

  def full_name
    [first_name, last_name].compact.join(" ")
  end
end
