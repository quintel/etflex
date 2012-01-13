class ScenariosController < ApplicationController
  include ETFlex::ClientController
  helper  ScenesHelper

  # Shows the JSON for a given scene, with extra information about the
  # scenario embedded within so that they client loads a specific ET-Engine
  # session.
  #
  # GET /scenes/:scene_id/scenarios/:id
  #
  def show
    @scenario = Scenario.where(params.slice(:scene_id, :id)).first!
    @scene    = @scenario.scene

    respond_with @scenario
  end

  # Creates a new Scenario record.
  #
  # The client hits this action when it creates a new ET-Engine session so
  # that we may resume the users sessions later.
  #
  # POST /scenes/:scene_id/scenarios
  #
  def create
  end

end # ScenariosController
