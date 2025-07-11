class ContentSpacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_content_space, only: %i[show edit update destroy]

  def index
    spaces = policy_scope(@organization.content_spaces)

    if policy(@organization).update?
      @content_spaces = spaces
    else
      @content_spaces = spaces.for_age(current_user.age)
    end
  end

  def show
    authorize @content_space
    @contents = @content_space.contents.select { |c| c.accessible_by?(current_user) }
  end

  def new
    @content_space = @organization.content_spaces.build
    authorize @content_space
  end

  def create
    @content_space = @organization.content_spaces.build(content_space_params)
    authorize @content_space
    if @content_space.save
      redirect_to organization_content_space_path(@organization, @content_space), notice: 'Space created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @content_space
  end

  def update
    authorize @content_space
    if @content_space.update(content_space_params)
      redirect_to organization_content_space_path(@organization, @content_space), notice: 'Space updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @content_space
    @content_space.destroy
    redirect_to organization_content_spaces_path(@organization), notice: 'Space removed.'
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def set_content_space
    @content_space = @organization.content_spaces.find(params[:id])
  end

  def content_space_params
    params.require(:content_space).permit(:name, :min_age, :max_age)
  end
end
