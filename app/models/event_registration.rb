class EventRegistration < ApplicationRecord
  belongs_to :event, optional: true
  belongs_to :member, optional: true
end
