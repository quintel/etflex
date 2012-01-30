{ InputManager } = require 'lib/input_manager'
{ Balancer }     = require 'lib/balancer'

# Contains all of the Inputs. The main instantiated collection can be found
# on app.collections.inputs.
#
class exports.Inputs extends Backbone.Collection
  model: require('models/input').Input

  # Sets up the balancers for the collection; without this no balancing will
  # be performed when inputs belonging to groups are changed.
  #
  # Presently this has to be called explicitly in Scene::start becuase
  # Backbone doesn't seem to have an "add" callback on Collection.
  #
  initializeBalancers: ->
    @balancers = {}

    for model in @models when group = model.def.group
      @balancers[ group ] or= new Balancer
      @balancers[ group ].add model

  # Sets the session to which the inputs contained in the collection belong.
  #
  # scenario - The ET-Engine scenario to which the input values should be sent
  #            when changed.
  #
  persistTo: (scenario) ->
    if sessionId = scenario.get 'sessionId'
      @manager = new InputManager sessionId
    else
      throw 'Cannot persist inputs to a scenario which has no sessionId'

  # Given a group name, performs balancing so that the sliders in the group
  # other than "master" have their values adjusted so that the group sums to
  # 100.
  #
  # Inputs whose values are changed will be returned in an array.
  #
  # master - The input whose value was adjusted by the user and should not be
  #          balanced automatically.
  #
  balance: (groupName, master) ->
    @balancers[ groupName ].performBalancing master
