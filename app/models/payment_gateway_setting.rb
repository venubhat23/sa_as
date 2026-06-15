class PaymentGatewaySetting < ApplicationRecord
  validates :gateway_name, presence: true
end
