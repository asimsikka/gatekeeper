module ApplicationHelper
  def admin_for?(org)
    current_user.memberships.find_by(organization: org)&.admin?
  end

  def member_for?(org)
    current_user.memberships.find_by(organization: org)&.member?
  end
end
