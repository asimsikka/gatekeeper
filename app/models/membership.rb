class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum :role,   { admin: "admin", manager: "manager", member: "member" }
  enum :status. { invited: "invited", pending: "pending", active: "active", rejected: "rejected" }

  before_create :generate_invitation_token, if: -> { invited? }

  scope :members_only, -> { where(role: :member) }
  scope :admins_only,  -> { where(role: :admin) }

  validates :role,   inclusion: { in: roles.keys }
  validates :status, inclusion: { in: statuses.keys }
  validates :user_id, uniqueness: { scope: :organization_id }

  private

  def generate_invitation_token
    self.invitation_token   = SecureRandom.urlsafe_base64(24)
    self.invitation_sent_at = Time.current
  end
end
