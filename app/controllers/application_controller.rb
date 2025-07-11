class ApplicationController < ActionController::Base
  include Pundit::Authorization

  allow_browser versions: :modern
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!
  before_action :ensure_parental_consent

  protected

  def after_sign_in_path_for(resource)
    if resource.minor? && !resource.parental_consent?
      new_parental_consent_path(user_id: resource.id)
    else
      super
    end
  end

  private

  def ensure_parental_consent
    return unless user_signed_in?
    return unless current_user.minor? && !current_user.parental_consent?

    if controller_name == 'parental_consents' && %w[new create edit update].include?(action_name)
      return
    elsif devise_controller? && action_name == 'destroy'
      return
    end

    redirect_to new_parental_consent_path(user_id: current_user.id),
                alert: 'You must have parental consent to continue.'
  end

  def user_not_authorized
    flash[:alert] = "Access denied."
    redirect_to(request.referrer || root_path)
  end
end
