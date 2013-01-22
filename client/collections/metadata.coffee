class exports.MetadataCollection extends Backbone.Collection
  constructor: (models, options) ->
    super models, options

    @_meta = options?.meta || {}

  meta: (prop, value) ->
    if value?
      @_meta[prop] = value

    @_meta[prop]
