class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!

  private

  def user_not_authorized
    flash[:alert] = "Access denied."
    redirect_to(request.referrer || root_path)
  end
end
