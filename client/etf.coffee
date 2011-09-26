# ETF is used as a namespace for CoffeeScript classes, rather than throwing
# everything on to `window`.
#
@ETF = {}

# $etf contains the main application router, as well as any other objects
# which are considered "singletons", such as full-page views.
#
# Keeping the full-page views, instead of recreating them each time the user
# changes page, allows us to reuse the same DOM objects which is both faster,
# and means that the page is in the exact same state as when the user left.
#
@$etf =
  router: null
  collections: {}

  # Hold a singleton copy of the Views used by this router. Views probably
  # ought to be instantiated lazily, but I'll investigate this later...
  views: {}

  bootstrap: ->
    @views.sanity = new ETF.SanityView().render()
    @views.etlite = new ETF.ETLiteView().render()

    # Start the router; this is temporary until a proper boostrap process is
    # in place.
    @router = new ETF.Router
    Backbone.history.start()
