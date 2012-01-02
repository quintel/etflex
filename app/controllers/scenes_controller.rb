class ScenesController < ApplicationController
  include ETFlex::ClientController
  helper  ScenesHelper

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

end # ScenesController
