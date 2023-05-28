class ApplicationController < ActionController::Base

  before_action :set_locale

  protected
  def authorize_user
    redirect_to login_path unless current_user
  end

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def current_user
    @current_user ||= User.find_by_id(session[:current_user])
  end
end