class ApplicationController < ActionController::Base
  include Authentication
  include SessionHelper
  helper_method :logged_in?, :current_user


end
