class Forum < ApplicationRecord
  has_many :chapters, dependent: :nullify
  has_many :members, dependent: :nullify
  validates :name, presence: true
  scope :active, -> { where(status: "active") }
end
