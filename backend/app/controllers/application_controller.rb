class ApplicationController < ActionController::Base
  include Authentication
  include SessionHelper
  helper_method :logged_in?, :current_user

  before_action :authenticate_user!

  private

  def authenticate_user!
    redirect_to login_path unless current_user
  end
end
