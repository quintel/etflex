class ScenariosController < ApplicationController
  include ETFlex::ClientController
  helper  ScenesHelper

  # HELPERS ------------------------------------------------------------------

  #######
  private
  #######

  def new_scenario
    Scenario.new do |scenario|
      scenario.user       = current_user
      scenario.scene      = Scene.find(params[:scene_id])
      scenario.session_id = params[:id]
    end
  end

  def scenario_attrs
    attrs = params[:scenario] || Hash.new

    # TODO Have the client send input_values, query_results, instead.
    attrs[:input_values]  = attrs.delete(:inputValues)
    attrs[:query_results] = attrs.delete(:queryResults)

    attrs
  end

  # ACTIONS ------------------------------------------------------------------

  ######
  public
  ######

  # Shows the JSON for a given scene, with extra information about the
  # scenario embedded within so that they client loads a specific ET-Engine
  # session.
  #
  # GET /scenes/:scene_id/with/:id
  #
  def show
    @scenario   = Scenario.for_session *params.values_at(:scene_id, :id)
    @scenario ||= new_scenario

    respond_with @scenario
  end

  # Creates or updates a Scenario record.
  #
  # The client hits this action when it creates a new ET-Engine session so
  # that we may resume the users sessions later.
  #
  # PUT /scenes/:scene_id/with/:id
  #
  def update
    @scenario   = Scenario.for_session *params.values_at(:scene_id, :id)
    @scenario ||= new_scenario

    if @scenario.persisted? and @scenario.user_id != current_user.id
      return head :forbidden
    end

    @scenario.attributes = scenario_attrs if params[:scenario].present?
    @scenario.save

    respond_with @scenario, location: scene_scenario_url
  end

end # ScenariosController
