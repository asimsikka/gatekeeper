class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_membership, only: %i[edit update destroy accept]

  def index
    @memberships = policy_scope(@organization.memberships)
    authorize @memberships
  end

  def new
    @membership = @organization.memberships.build
    authorize @membership
  end

  def create
    @membership = @organization.memberships.build(membership_params)
    authorize @membership
    if @membership.save
      redirect_to organization_memberships_path(@organization), notice: 'Invitation sent successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @membership
  end

  def update
    authorize @membership
    if @membership.update(membership_params)
      redirect_to organization_memberships_path(@organization), notice: 'Membership updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @membership
    @membership.destroy
    redirect_to organization_memberships_path(@organization), notice: 'Membership removed.'
  end

  def accept
    authorize @membership, :update?
    unless @membership.invited? && @membership.invitation_sent_at > 7.days.ago
      redirect_to root_path, alert: 'Expired or invalid.' and return
    end

    if user_signed_in?
      if current_user.email == @membership.invite_email
        @membership.update!(user: current_user, status: :active, invitation_token: nil)
        redirect_to organization_path(@organization), notice: 'Welcome aboard!'
      else
        redirect_to root_path, alert: 'This invite isn’t for your account.'
      end
    else
      session[:pending_membership_id] = @membership.id
      redirect_to new_user_session_path,
                  alert: 'Please sign in or sign up to accept your invite.'
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def set_membership
    @membership = @organization.memberships.find(params[:id])
  end

  def membership_params
    params.require(:membership).permit(:user_id, :role, :status, :invite_email)
  end
end
