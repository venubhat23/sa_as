class SidebarAccess < ApplicationRecord
  belongs_to :role
  validates :menu_key, presence: true
end
