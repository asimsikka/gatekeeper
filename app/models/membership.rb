class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum :role, { member: 0, admin: 1 }

  scope :members_only, -> { where(role: :member) }
  scope :admins_only,  -> { where(role: :admin) }

  validates :role, presence: true
end
