class ApplicationController < ActionController::Base
  include Pundit

  allow_browser versions: :modern
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  private

  def user_not_authorized
    flash[:alert] = "Access denied."
    redirect_to(request.referrer || root_path)
  end
end
