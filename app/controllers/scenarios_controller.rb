class ScenariosController < ApplicationController
  include ETFlex::ClientController
  helper  ScenesHelper

  # HELPERS ------------------------------------------------------------------

  #######
  private
  #######

  def new_scenario_attrs
    { user:       current_user,
      scene:      Scene.find(params[:scene_id]),
      session_id: params[:id] }
  end

  # ACTIONS ------------------------------------------------------------------

  ######
  public
  ######

  # Shows the JSON for a given scene, with extra information about the
  # scenario embedded within so that they client loads a specific ET-Engine
  # session.
  #
  # GET /scenes/:scene_id/scenarios/:id
  #
  def show
    @scenario   = Scenario.for_session *params.values_at(:scene_id, :id)
    @scenario ||= Scenario.new new_scenario_attrs

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
    @scenario = Scenario.create new_scenario_attrs
    respond_with [ :scene, @scenario ]
  end

end # ScenariosController
