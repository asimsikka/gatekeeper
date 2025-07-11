class OrganizationsController < ApplicationController
  # include Pundit
  before_action :authenticate_user!
  before_action :set_organization, only: %i[show edit update destroy analytics]
  before_action :authorize_organization, only: %i[show edit update destroy]

  def index
    @organizations = policy_scope(Organization)
  end

  def show; end

  def new
    @organization = Organization.new
    authorize @organization
  end

  def edit; end

  def create
    @organization = Organization.new(organization_params)
    authorize @organization

    respond_to do |format|
      if @organization.save
        current_user.memberships.create!(organization: @organization, role: :admin, status: :active)

        format.html { redirect_to @organization, notice: "Organization was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: "Organization was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @organization.destroy!

    respond_to do |format|
      format.html { redirect_to organizations_path, status: :see_other, notice: "Organization was successfully destroyed." }
    end
  end

  def analytics
    authorize @organization, :analytics?

    all_members = @organization.memberships
    @memberships = all_members.members_only.includes(:user)
    @admins = all_members.admins_only
    @pending_invites = all_members.invited.count

    @total_members = @memberships.count
    @admin_count = @admins.count
    @member_count = @memberships.count
    @recent_members = @memberships.order(created_at: :desc).limit(5)

    @spaces_count    = @organization.content_spaces.count
    @content_count   = Content.joins(:content_space).where(content_spaces: { organization_id: @organization.id }).count

  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :email_domain, :description)
  end

  def authorize_organization
    authorize @organization
  end
end
