class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate!

  helper_method :current_user

  rescue_from Koala::Facebook::ClientError, with: :snackbar
  rescue_from Koala::Facebook::AuthenticationError, with: :logout

  include Tabbable

  def authenticate!
    redirect_to new_user_path unless current_user
  end

  # @param user [User]
  def current_user=(user)
    session[:user_id] = user.id
  end

  # @return [User]
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    reset_session # user has an invalid session
  end

  protected

  # @param reason [Koala::Facebook::AuthenticationError|String]
  def logout(reason)
    reason = reason.fb_error_message if reason.is_a?(Koala::Facebook::AuthenticationError)
    reset_session
    respond_to do |format|
      format.html { redirect_to new_user_path, alert: reason }
      format.js do
        render inline:(<<~JS)
          Turbolinks.visit('#{new_user_path}');
          var notification = document.querySelector('.mdl-js-snackbar');
          notification.MaterialSnackbar.showSnackbar({message: '#{reason}'});
        JS
      end
    end
  end

  # @param exception [Koala::Facebook::ClientError]
  def snackbar(exception)
    pp exception
    respond_to do |format|
      format.js do
        render inline:(<<~JS)
          var notification = document.querySelector('.mdl-js-snackbar');
          notification.MaterialSnackbar.showSnackbar({message: '#{exception.fb_error_message}'});
        JS
      end
    end
  end
end
