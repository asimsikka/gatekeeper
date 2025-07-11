class OrganizationsController < ApplicationController
  include Pundit
  # before_action :set_organization, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :set_organization, only: %i[show edit update destroy analytics]
  before_action :authorize_organization, only: %i[show edit update destroy]

  # GET /organizations or /organizations.json
  def index
    # @organizations = current_user.organizations
    @organizations = policy_scope(Organization)
  end

  # GET /organizations/1 or /organizations/1.json
  def show; end

  # GET /organizations/new
  def new
    @organization = Organization.new
    authorize @organization
  end

  # GET /organizations/1/edit
  def edit; end

  # POST /organizations or /organizations.json
  def create
    @organization = Organization.new(organization_params)
    authorize @organization

    respond_to do |format|
      if @organization.save
        # Auto-add creator as admin
        current_user.memberships.create!(organization: @organization, role: :admin)

        format.html { redirect_to @organization, notice: "Organization was successfully created." }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1 or /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: "Organization was successfully updated." }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1 or /organizations/1.json
  def destroy
    @organization.destroy!

    respond_to do |format|
      format.html { redirect_to organizations_path, status: :see_other, notice: "Organization was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def analytics
    # @organization = Organization.find(params[:id])
    authorize @organization, :analytics?

    all_members = @organization.memberships
    @memberships = all_members.members_only.includes(:user)
    @admins = all_members.admins_only

    @total_members = @memberships.count
    @admin_count = @admins.count
    @member_count = @memberships.count
    @recent_members = @memberships.order(created_at: :desc).limit(5)
    # @minors = @memberships.select { |m| m.user.minor? }.count
    # @adults = @total_members - @minors
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name)
  end

  def authorize_organization
    authorize @organization
  end
end
