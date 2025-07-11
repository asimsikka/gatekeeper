class ParentalConsentsController < ApplicationController
  before_action :set_user, only: %i[new create]
  before_action :set_consent, only: %i[edit update]
  skip_before_action :authenticate_user!, only: %i[edit update]

  def new
    @consent = ParentalConsent.new(user: @user)
    authorize @consent
  end

  def create
    @consent = ParentalConsent.new(consent_params.merge(user: @user))
    authorize @consent
    if @consent.save
      ParentalConsentMailer.consent_request_email(@consent).deliver_later
      redirect_to root_path, notice: 'Consent request sent.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if @consent.approved?
      redirect_to root_path, notice: 'This consent link is no longer valid.'
    end
  end

  def update
    if @consent.approve! && @consent.user.update!(parental_consent: true)
      redirect_to new_user_session_path, notice: 'Thank you!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id] || consent_params[:user_id])
  end

  def set_consent
    @consent = ParentalConsent.find_by!(token: params[:token])
  end

  def consent_params
    params.require(:parental_consent).permit(:guardian_email, :user_id)
  end
end
