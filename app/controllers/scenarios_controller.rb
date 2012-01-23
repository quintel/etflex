class ScenariosController < ApplicationController
  include ETFlex::ClientController
  helper  ScenesHelper

  # HELPERS ------------------------------------------------------------------

  #######
  private
  #######

  def scenario_attrs
    scenario = params.fetch(:scenario, Hash.new)

    { user:       current_user,
      scene:      Scene.find(params[:scene_id]),
      session_id: params[:id],
      title:      scenario[:title] }
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
    @scenario ||= Scenario.new scenario_attrs

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
    @scenario ||= Scenario.new

    if @scenario.persisted? and @scenario.user_id != current_user.id
      return head :forbidden
    end

    @scenario.attributes = scenario_attrs
    @scenario.save

    respond_with [ :scene, @scenario ]
  end

end # ScenariosController
