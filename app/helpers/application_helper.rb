module ApplicationHelper
  def admin_for?(org)
    current_user.memberships.find_by(organization: org)&.admin?
  end

  def member_for?(org)
    current_user.memberships.find_by(organization: org)&.member?
  end

  def membership_access_status(user)
    return "Pending Invite" unless user.present?

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
end
