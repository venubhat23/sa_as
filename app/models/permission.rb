class Permission < ApplicationRecord
  belongs_to :role
  validates :module_name, presence: true
end
