# A collectin which holds all of the Module instances which the client knows
# about. Note that this collection does not contain _every_ module which is
# defined on the server; a module must first be fetched from the server and
# added to the collection.
#
# TODO: Override "get" so that we fetch automatically? Backbone isn't async.
#       in this regard, so, urgh...
#
class exports.Modules extends Backbone.Collection
  model: require('models/module').Module
