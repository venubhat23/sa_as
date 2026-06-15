class Location < ApplicationRecord
  belongs_to :region, optional: true
  belongs_to :chapter, optional: true
  validates :name, presence: true
end
