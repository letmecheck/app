class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :update_last_request_at
  protect_from_forgery with: :exception

  def update_last_request_at
    current_user.update_attribute(:last_request_at, Time.now.utc) if current_user
  end
end
