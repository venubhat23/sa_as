class EmailTemplate < ApplicationRecord
  validates :name, presence: true
  scope :active, -> { where(status: "active") }
end
