class BusinessCategory < ApplicationRecord
  has_many :business_specialties, dependent: :nullify
  has_many :members, dependent: :nullify
  has_many :guests, dependent: :nullify
  validates :name, presence: true
  scope :active, -> { where(status: "active") }
end
