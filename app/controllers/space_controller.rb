class SpaceController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :authorize_participation!

  def show
    @age_group = current_user.age_group
  end

  private

  def set_organization
    @organization = current_user.organizations.find(params[:id])
  # rescue ActiveRecord::RecordNotFound
  #   redirect_to root_path, alert: "You do not belong to this organization."
  end

  def authorize_participation!
    if current_user.underage? && !current_user.parental_consent?
      redirect_to root_path, alert: "Parental consent required to access this space."
    end
  end
end
