class ApplicationController < ActionController::Base
  protect_from_forgery

  # RESCUES ------------------------------------------------------------------

  rescue_from User::NotAuthorised do
    render file: Rails.root.join('public/404.html'),
           status: :not_found, layout: false
  end

  # FILTERS ------------------------------------------------------------------

  #######
  private
  #######

  layout :layout_by_resource

  before_filter :set_locale
  before_filter :handle_guest_uid

  helper_method :guest_user
  helper_method :current_or_guest_user

  # Sets the language to be used for the user; permits setting it through the
  # +locale+ query param.
  #
  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  # Guests have a unique ID set so that they may save their scenarios.
  #
  def handle_guest_uid
    if user_signed_in? and cookies[:guest_uid]
      cookies.delete :guest_uid
    elsif ! user_signed_in? and cookies[:guest_uid].blank?
      cookies.permanent.signed[:guest_uid] = {
        httponly: true, value: SecureRandom.uuid }
    end
  end

  # Returns the Guest instance for the current user. Will return nil if the
  # user is signed into a registered account.
  #
  def guest_user
    @_guest ||= Guest.new cookies.signed[:guest_uid] unless user_signed_in?
  end

  # Returns the currently signed in user, or the Guest instance if the user
  # is not signed in.
  #
  def current_or_guest_user
    if user_signed_in? then current_user else guest_user end
  end

  ##########
  protected
  ##########

  # Set the layout to Backstage's for all Devise views
  #
  #
  def layout_by_resource
    devise_controller? ? 'backstage' : nil
  end

end
