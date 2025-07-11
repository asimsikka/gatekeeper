class SpaceController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization

  def show
    return render "consents/request" if current_user.needs_parental_consent?

    @age_group = current_user.age_group
  end

  private

  def set_organization
    @organization = current_user.organizations.find(params[:id])
  end
end
