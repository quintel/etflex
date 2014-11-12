class ScenariosController < ApplicationController
  include ETFlex::ClientController
  helper  ScenesHelper

  before_filter :enable_or_disable_scores,  only: :show
  skip_before_filter :restrict_html_to_get, only: :lock

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
        scenario.guest_uid  = guest_user.id
        scenario.guest_name = guest_user.name
      end
    end
  end

  # Converts the JS-style keys (e.g. inputValues) into Ruby-style keys
  # (e.g. input_values).
  def scenario_attrs
    attrs = params[:scenario] || Hash.new
    keys  = %w( title inputValues queryResults endYear country guestName )

    keys.each_with_object(Hash.new) do |key, data|
      data[key.underscore] = attrs[key] if attrs.key?(key)
    end
  end

  # Sends notification to Pusher that a user did something.
  #
  # event    - The event type: "created" or "updated" depending on whether the
  #            user modified their existing scenario, or started a new one.
  #
  # scenario - The scenario in question.
  #
  def scenario_pusher(event, scenario)
    pusher "scenario.#{ event }", scenario.to_pusher_event
  end

  # ACTIONS ------------------------------------------------------------------

  ######
  public
  ######

  # JSON-only action which returns a list of high-scoring scenarios which have
  # been updated within the previous :days.
  #
  # GET /scene/:scene_id/scenarios/since/:days
  #
  def since
    return head :bad_request unless params[:days].match(/\A\d+\Z/)

    @scene = Scene.find params[:scene_id]

    @scenarios = @scene.high_scores_since(params[:days].to_i.days.ago)
    @scenarios = @scenarios.map(&:to_pusher_event)

    respond_with @scenarios
  end

  # Shows the JSON for a given scene, with extra information about the
  # scenario embedded within so that they client loads a specific ETengine
  # session.
  #
  # GET /scenes/:scene_id/with/:id
  #
  def show
    unless @scenario = Scenario.for_session(*params.values_at(:scene_id, :id))
      raise ActiveRecord::RecordNotFound
    end

    respond_with @scenario
  end

  # Creates or updates a Scenario record.
  #
  # The client hits this action when it creates a new ETengine session so
  # that we may resume the users sessions later.
  #
  # PUT /scenes/:scene_id/with/:id
  #
  def update
    @scenario   = Scenario.for_session *params.values_at(:scene_id, :id)
    @scenario ||= new_scenario

    return head :forbidden unless @scenario.can_change?(current_or_guest_user)

    event = if @scenario.new_record? then 'created' else 'updated' end

    @scenario.attributes = scenario_attrs if params[:scenario].present?
    @scenario.save

    if params[:scenario] && name = params[:scenario][:guestName]
      if guest_user.present?
        guest_user.name = name
        guest_user.save(cookies)
      else
        current_user.update_attributes(name: name)
      end
    end

    respond_with @scenario, location: scene_scenario_url

    # Send information about the update to connected clients.
    scenario_pusher(event, @scenario) if scores_enabled?
  end

  # Locks a scenario preventing the user from making any further changes.
  # Redirect back to to the survey.
  #
  # GET /scenes/:scene_id/with/:id/lock
  #
  def lock
    unless @scenario = Scenario.for_session(*params.values_at(:scene_id, :id))
      raise ActiveRecord::RecordNotFound
    end

    @scenario.update_attribute(:locked, true)

    redirect_to(guest_user.survey_callback_url)
  end

end # ScenariosController
