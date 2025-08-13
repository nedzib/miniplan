class ApplicationController < ActionController::Base
  include Authentication
  helper MoneyHelper
  helper_method :current_user
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
