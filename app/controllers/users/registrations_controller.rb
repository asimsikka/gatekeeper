class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      if user.persisted? && user.minor?
        flash[:notice] = 'Parental consent required'
        redirect_to new_parental_consent_path(user_id: user.id) and return
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :date_of_birth, :password, :password_confirmation, :guardian_email, :parental_consent)
  end
end
