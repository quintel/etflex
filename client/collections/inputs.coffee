# Contains all of the Inputs used by a Scene.
class exports.Inputs extends Backbone.Collection
  model: require('models/input').Input

  # Sets the session to which the inputs contained in the collection belong.
  #
  # scenario - The ETengine scenario to which the input values should be sent
  #            when changed.
  #
  persistTo: (scenario) ->
    # if sessionId = scenario.get 'sessionId'
    #   @manager = new InputManager sessionId
    # else
    #   throw 'Cannot persist inputs to a scenario which has no sessionId'

  # Performs balancing so that the sliders in the group have their values
  # adjusted so that the group sums to 100.
  #
  # Inputs whose values are changed will be returned in an array.
  #
  # master - The input whose value was adjusted by the user and should not be
  #          balanced automatically.
  #
  balance: (groupName, master) ->
    # @balancers[ groupName ].performBalancing master
