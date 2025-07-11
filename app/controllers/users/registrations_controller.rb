class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      if user.persisted? && user.age < 13
        consent = user.parental_consents.create!(guardian_email: sign_up_params[:guardian_email])
        ParentalConsentMailer.consent_request_email(consent).deliver_later
        sign_out user
        flash[:alert] = 'Parental consent required. Check email for approval link.'
        redirect_to new_parental_consent_path(user_id: user.id) and return
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :date_of_birth, :password, :password_confirmation, :guardian_email, :parental_consent)
  end
end
