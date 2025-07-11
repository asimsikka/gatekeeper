class ParentalConsentPolicy < ApplicationPolicy
  def new?
    user.present? && !user.adult?
  end

  def create?
    new?
  end

  def edit?
    record.user == user
  end

  def update?
    edit?
  end

  class Scope < Scope
    def resolve
      ParentalConsent.none
    end
  end
end
