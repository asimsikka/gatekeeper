class OrganizationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      user.organizations
    end
  end

  def index?
    true
  end

  def show?
    user_in_org?
  end

  def update?
    admin_in_org?
  end

  def destroy?
    admin_in_org?
  end

  def create?
    true
  end

  def analytics?
    admin_in_org?
  end

  private

  def user_in_org?
    user.organizations.include?(record)
  end

  def admin_in_org?
    user.memberships.find_by(organization: record)&.admin?
  end
end
