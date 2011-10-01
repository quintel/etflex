# app.coffee contains the instance of the main application router, as
# well as any other objects which are considered "singletons", such as
# full-page views.

# Holds the router singleton. For the moment the application has only
# one; in time we may add more.
exports.router = null

# Holds each of the main model collections (Sliders, Widgets, etc).
exports.collections = {}

# Called _once_ when the application is first loaded in the browser.
exports.bootstrap = (window) ->
  exports.router = new (require('router').Router)

  # Fire up Backbone routing...
  Backbone.history.start pushState: true
