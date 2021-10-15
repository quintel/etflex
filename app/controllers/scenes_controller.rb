class ScenesController < ApplicationController
  include ETFlex::ClientController
  helper  ScenesHelper

  before_action :enable_or_disable_scores, only: :show

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

end # ScenesController
