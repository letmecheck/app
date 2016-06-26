class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :update_last_request_at
  protect_from_forgery with: :exception

  def update_last_request_at
    if current_user
      current_user.last_request_at = Time.now.utc
      current_user.save
    end
  end
end
