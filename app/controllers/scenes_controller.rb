class ScenesController < ApplicationController
  include ETFlex::ClientController
  helper  ScenesHelper

  before_filter :enable_or_disable_scores, only: :show

  # Shows a list of all available scenes.
  #
  # GET /scenes
  #
  def index
    respond_with @scenes = Scene.all
  end

  # Renders a scene in full, with all the inputs, props, etc.
  #
  # GET /scenes/:id
  #
  def show
    respond_with @scene = Scene.find(params[:id])
  end

  # Used as a temporary fix for conferences where clicking "start over" should
  # begin a completely new session so that another visitor may use the site
  # without interfering with previous users' scenarios.
  #
  # Only works for guests; nothing will happen if the session belongs to a
  # registered user.
  #
  # Redirects back to the scene.
  #
  # GET /scenes/:id/fresh
  #
  def fresh
    reset_guest! if guest_user
    redirect_to scene_path(params[:id])
  end

  # An action for visitors from the survey. Identifies the visitor by a token
  # so that repeat visits may be sent back to their scenario, even though the
  # client's application does not know the scenario ID.
  #
  # Redirects to the scenario.
  #
  # GET /as/:token
  #
  def survey
    reset_guest!

    session[:locale] = :nl
    token = params[:token].strip

    set_guest(Guest.new(token, token))

    if existing = Scenario.for_user(guest_user).first
      redirect_to scene_scenario_url(
        scene_id: existing.scene_id, id: existing.session_id)
    else
      redirect_to Scene.find(1)
    end
  end

end # ScenesController
