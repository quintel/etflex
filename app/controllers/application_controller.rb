require 'ostruct'

class ApplicationController < ActionController::Base
  protect_from_forgery

  respond_to :html
  respond_to :json, only: :render_scene

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
    if options.nil? then { template: 'application/client' } else
      options.merge template: 'application/client'
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

  # A temporary action which renders a scene.
  #
  # This will be replaced with a full scenes controller once the ActiveRecord
  # model is implemented.
  #
  # GET /scenes/:id
  #
  def scene
    @scene = Scene.find(params[:id])

    # TODO Add a custom Responder so we may simply "render @scene".
    respond_to do |wants|
      wants.html { render client }
      wants.json { render }
    end
  end

  # A temporary action used while mocking up the Backstage layout.
  #
  # GET /backstage
  #
  def backstage
    render text: '', layout: 'backstage'
  end

end
