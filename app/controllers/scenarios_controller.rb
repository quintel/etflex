class ScenariosController < ApplicationController
  include ETFlex::ClientController
  helper  ScenesHelper

  # HELPERS ------------------------------------------------------------------

  #######
  private
  #######

  def new_scenario
    Scenario.new do |scenario|
      scenario.scene      = Scene.find(params[:scene_id])
      scenario.session_id = params[:id]

      if user_signed_in?
        scenario.user = current_user
      else
        scenario.guest_uid = guest_user.uid
      end
    end
  end

  def scenario_attrs
    attrs = params[:scenario] || Hash.new

    { title:         attrs[:title],
      input_values:  attrs[:inputValues],
      query_results: attrs[:queryResults] }
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

    return head :forbidden unless @scenario.can_change?(current_or_guest_user)

    @scenario.attributes = scenario_attrs if params[:scenario].present?
    @scenario.save

    respond_with @scenario, location: scene_scenario_url
  end

end # ScenariosController
