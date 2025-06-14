class ApplicationController < ActionController::Base
  include Authentication

  helper_method :current_user

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  layout :determine_layout

  def determine_layout
    authenticated? ? "application" : "guest"
  end

  def current_user
    @current_user ||= Current.user
  end
end
