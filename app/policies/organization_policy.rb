class OrganizationPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      # Only organizations the user belongs to
      user.organizations
    end
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
