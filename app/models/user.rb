class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :role, optional: true
  has_one :member, dependent: :nullify
  has_many :notifications, dependent: :destroy

  scope :active, -> { where(status: "active") }

  def display_name
    name.presence || email
  end
end
