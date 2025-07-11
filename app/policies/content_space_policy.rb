class ContentSpacePolicy < ApplicationPolicy
  def show?
    OrganizationPolicy.new(user, record.organization).show?
  end

  def create?
    OrganizationPolicy.new(user, record.organization).update?
  end

  def update?
    create?
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
