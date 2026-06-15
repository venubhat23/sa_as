class BusinessSpecialty < ApplicationRecord
  belongs_to :business_category, optional: true
  has_many :members, dependent: :nullify
  validates :name, presence: true
  scope :active, -> { where(status: "active") }
end
