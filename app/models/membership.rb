class Membership < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :organization

  enum :role,   { admin: "admin", manager: "manager", member: "member" }
  enum :status, { invited: "invited", pending: "pending", active: "active", rejected: "rejected" }

  validates :role,   inclusion: { in: roles.keys }
  validates :status, inclusion: { in: statuses.keys }
  validates :invite_email,
          presence: true,
          format: { with: URI::MailTo::EMAIL_REGEXP },
          if: -> { invited? }

  validates :invite_email,
            uniqueness: { scope: :organization_id },
            if: -> { invited? }

  validates :user_id,
            uniqueness: { scope: :organization_id },
            allow_nil: true

  before_create :generate_invitation_token, if: -> { invited? }
  after_create :send_invitation_email, if: -> { invited? }

  scope :members_only, -> { where(role: :member) }
  scope :admins_only,  -> { where(role: :admin) }


  def display_email
    user&.email.presence || invite_email || "Unknown"
  end

  def display_age_group
    user&.age_group.presence || "Unknown"
  end

  def consent_required?
    return nil unless user
    !user.adult?
  end

  def space_access_status
    return "Pending Invite" unless user

    if user.adult?
      "Accessible"
    elsif user.consent_approved_at.present?
      "Approved"
    elsif user.consent_sent_at.present?
      "Awaiting Approval"
    else
      "Blocked"
    end
  end

  def space_access_status_class
    case space_access_status
    when "Accessible", "Approved"
      "text-green-600"
    when "Awaiting Approval"
      "text-yellow-600"
    when "Blocked"
      "text-red-500"
    else
      "text-gray-500 italic"
    end
  end

  private

  def generate_invitation_token
    self.invitation_token   = SecureRandom.urlsafe_base64(24)
    self.invitation_sent_at = Time.current
  end

  def send_invitation_email
    MembershipMailer.invitation_email(self).deliver_later
  end
end
