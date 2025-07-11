class ConsentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:approve]

  def create
    if current_user.needs_parental_consent?
      email = params[:approver_email]

      current_user.generate_consent_token!
      ConsentMailer.approval_email(current_user, email).deliver_now

      redirect_to root_path, notice: "Consent request sent to #{email}"
    else
      redirect_to root_path, alert: "Consent not required"
    end
  end

  def approve
    user = User.find_by(consent_token: params[:token])

    if user && !user.parental_consent?
      user.approve_consent!
      redirect_to root_path, notice: "Parental consent approved"
    else
      redirect_to root_path, alert: "Invalid or expired token"
    end
  end

  private

  def consent_params
    params.require(:consent).permit(:approver_email)
  end
end
