class Role < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :permissions, dependent: :destroy
  has_many :sidebar_accesses, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  scope :active, -> { where(status: "active") }
end
