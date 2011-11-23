# A collection which contains raw fixture data from the server.
#
# This allows us to create a new collection, with new models each time a new
# scene is loaded by the user; providing each scene with a degree of
# isolation. You can freely bind events to the collection returned by
# "createCollection" -- or individual models -- without any of those events
# "spilling over" into other scenes.
#
# You should not bind any events to the Stencil collection, or it's models
# however as these will not be passed on to collections created with
# createCollection.
#
class Stencil extends Backbone.Collection
  model: Backbone.Model

  # Creates a new Stencil instance.
  #
  # collectionType - The constructor function for the collection type, e.g.
  #                  Inputs or Queries.
  # models         - The raw fixture JSON from the server.
  # options        - Any additional options used by Backbone (normally the
  #                  second argument to a collection constructor).
  #
  constructor: (@collectionType, args...) ->
    super args...

  # Returns the model whose ID matches "id", raising an error if it does not
  # exist. Like "get", but angrier.
  #
  # id - The ID of the model you want.
  #
  demand: (id) ->
    if model = @get(id) then model else
      throw "No such #{@collectionType::model.name}: #{id}"

  # Creates a new collection where the result contains the instantiated models
  # whose IDs are included in the given "ids" array.
  #
  # ids - The array containing a list of IDs; models whose ID is included in
  #       this array will be in the collection.
  #
  createCollection: (ids) =>
    new @collectionType ( @demand(id).attributes for id in ids )

# EXPORTS --------------------------------------------------------------------

# Creates a stencil, and returns it's "createCollection" method. See
# Stencil::constructor for documentation.
#
exports.createStencil = (args...) ->
  (new Stencil args...).createCollection
