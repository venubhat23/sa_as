class OneToOne < ApplicationRecord
  belongs_to :member1, class_name: "Member", optional: true
  belongs_to :member2, class_name: "Member", optional: true
end
