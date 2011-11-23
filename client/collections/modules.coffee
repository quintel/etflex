{ Module } = require 'models/module'

# A collection which holds all of the Module instances which the client knows
# about. Note that this collection does not contain _every_ module which is
# defined on the server; a module must first be fetched from the server and
# added to the collection.
#
# TODO: Override "get" so that we fetch automatically? Backbone isn't async.
#       in this regard, so, urgh...
#
class exports.Modules extends Backbone.Collection
  model: Module
  url:  'http://etflex.dev/scenes'

  # Returns the Module whose ID matches "id". If the module already exists in
  # the collection, the supplied "callback" will be run immediately. Otherwise
  # an XHR request will retrieve the module from the server, and the callback
  # will be run.
  #
  # id       - The ID of the module to be returned.
  # callback - Function to be run after the module is retrieved.
  #
  getOrFetch: (id, callback) ->
    if module = @get(id) then callback module else
      @add(module = new Module id: id)

      module.fetch
        error:   (module) -> callback true
        success: (module) -> callback null, module
