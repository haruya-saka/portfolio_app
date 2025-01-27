module SessionHelper
  def current_user
    if Current.session
      @current_user ||= Current.session.user
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def logout
    Current.session = nil
    @current_user = nil
  end
end