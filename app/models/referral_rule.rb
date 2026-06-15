class ReferralRule < ApplicationRecord
  scope :active, -> { where(status: "active") }
end
