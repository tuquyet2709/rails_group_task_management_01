class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true
  include SessionsHelper
  before_action :set_locale
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json{head :forbidden, content_type: "text/html"}
      format.html{redirect_to main_app.root_url, notice: exception.message}
      format.js{head :forbidden, content_type: "text/html"}
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:name]
    devise_parameter_sanitizer.permit :account_update, keys: [:name]
  end

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    if I18n.available_locales
           .map(&:to_s).include?(parsed_locale)
      parsed_locale
    end
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
