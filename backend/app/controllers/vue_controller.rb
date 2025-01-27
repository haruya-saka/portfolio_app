class VueController < ApplicationController
  allow_unauthenticated_access
  
  def index
    authenticated? # セッションを再開する
    Rails.logger.debug "Rendering VueController#index"
    Rails.logger.debug "Current user: #{Current.user.inspect}"
    @current_user = Current.user
  end
end