class ApplicationController < ActionController::Base
  protect_from_forgery

  # FILTERS ------------------------------------------------------------------

  #######
  private
  #######

  before_filter :set_locale

  # Sets the language to be used for the user; permits setting it through the
  # +locale+ query param.
  #
  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  # ACTIONS ------------------------------------------------------------------

  ######
  public
  ######

  # A temporary action used to verify that Haml, RSpec, and other dependencies
  # are correctly configured.
  #
  # GET /sanity
  #
  def sanity
  end

end
