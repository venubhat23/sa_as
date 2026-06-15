class Region < ApplicationRecord
  has_many :locations, dependent: :nullify
  validates :name, presence: true
  scope :active, -> { where(status: "active") }
end
