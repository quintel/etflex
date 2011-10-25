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

  # Returns a hash which may be used in conjunction with `render` so that you
  # may simply
  #
  #   render client
  #
  # Pass extra rendering options to `client` has a hash, like so:
  #
  #   render client(meaning: 42)
  #
  def client(options = nil)
    if options.nil? then { template: 'application/sanity' } else
      options.merge template: 'application/sanity'
    end
  end

  # ACTIONS ------------------------------------------------------------------

  ######
  public
  ######

  # A temporary action used to verify that Haml, RSpec, and other dependencies
  # are correctly configured.
  #
  # GET /
  #
  def render_client
    render client
  end

end
