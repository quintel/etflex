# Creates a new collection of type "constructor". It will contain the models
# whose IDs match those in the "ids" array, sourced from "rawModels".
#
# "rawModels" is the original JSON sent from the server when the application
# loaded. collectionFromRaw will return a new instance of the collection, and
# the models contained therein will be created from scratch. This provides
# each module with a degree of isolation; you can freely bind events to the
# collection -- or individual models -- without any of those events "spilling
# over" into other modules.
#
# constructor - The collection constructor, such as Inputs, or Queries.
#
# ids         - The array containing a list of IDs; models whose ID is
#               included in this array will be in the collection.
#
# rawModels   - The raw JSON from the server.
#
exports.collectionFromRaw = (constructor, ids, rawModels) ->
  collection = new constructor (
    for id in ids
      model = _.find rawModels, (model) -> model.id is id
      throw "No such #{constructor::model.name}: #{id}" unless model?

      model )
