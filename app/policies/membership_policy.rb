class MembershipPolicy < ApplicationPolicy
  def index?
    OrganizationPolicy.new(user, record.first&.organization || record&.organization).show?
  end

  def show?
    record.user == user || index?
  end

  def create?
    OrganizationPolicy.new(user, record.organization).update?
  end

  def update?
    (record.invited? && record.invite_email == user.email) ||
    OrganizationPolicy.new(user, record.organization).update?
  end

  def destroy?
    create?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
