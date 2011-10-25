app           = require 'app'
template      = require 'templates/scenario'

{ Inputs }    = require 'collections/inputs'
{ Queries }   = require 'collections/queries'
{ RangeView } = require 'views/range'

# Scenario -------------------------------------------------------------------

# The heart of ETflex; given a Scenario model creates an HTML representation
# displaying the left and right sliders, visualisations, etc.
#
class exports.ScenarioView extends Backbone.View
  className: 'scenario-view'

  # Creates a new Scenario view.
  #
  # Sets the @inputs collection which will contain the Input instances used by
  # the view; and the @queries collection which includes the queries used by
  # the visualisations.
  #
  # You must supply a "model" attribute.
  #
  constructor: ->
    super

    # Create a subset of Inputs containing the inputs used by this view.
    #
    # TODO I think it would be better to hold on to the JSON definition of the
    #      inputs and create a completely new set of Input models, rather than
    #      reusing those from the global collection (which should itself be
    #      removed).
    #
    @inputs = collectionSubset app.collections.inputs,
      @model.get('leftInputs').concat @model.get('rightInputs')

  # Creates the HTML elements for the view, and binds events. Returns self.
  #
  # Example:
  #
  #   view = new Scenario model: scenario
  #   $('body').html view.render().el
  #
  render: ->
    $(@el).html template()
    this

# Helpers --------------------------------------------------------------------

# Given a collection, creates a "subset" of the collection containing only
# those models whose ID is in "ids".
#
# collection - An instance of Backbone.Collection.
# ids        - The IDs of the models which will be in the new collection.
#
collectionSubset = (collection, ids) ->
  new collection.constructor ( collection.get(id) for id in _.uniq ids )
