app = require 'app'

# A Singleton master view which delegates rendering of individual pages to
# sub-views (such as the ETlite recreation, etc).
#
# The `Master` view is initialized during the boot and stored on
# `app.masterView`.
#
class exports.MasterView extends Backbone.View
  el: 'body'

  # The currently rendered sub-view, or null if the page is still being
  # loaded.
  currentView: null

  # The function bound to the change event on the subset of inputs used by the
  # current view; held here so that we can unbind if rendering a different
  # view.
  #
  inputChangeEvent: null

  # The inputs being manipulated in the currently rendered view.
  #
  inputs: null

  # The queries whose results are shown in the currently rendered view.
  #
  queries: null

  # Given a new `View` instance, destructs the current sub-view, then renders
  # the new view and replaces the page contents with it.
  #
  # view - The new view to be rendered and added to the page.
  #
  setSubView: (view) ->
    isFirstView = not @currentView?

    # Removes the onChange event bound to the inputs in the current view (if
    # there is one), since the new view likely cares about a completely
    # different set of inputs.
    #
    @inputs?.unbind 'change:value', @inputChangeEvent

    # Set up the new view.

    @currentView = view

    # Views which define a set of dependant queries and/or inputs should have
    # a sub-set of those models made available.

    if view.dependantQueries
      @queries = app.collections.queries.subset view.dependantQueries
    else
      @queries = null

    if view.dependantInputs
      @inputs = app.collections.inputs.subset view.dependantInputs
      @inputChangeEvent = (input) => input.save {}, queries: @queries

      @inputs.bind 'change:value', @inputChangeEvent
    else
      @inputs = null

    # Render the view after updating the queries to reflect the latest data.

    doRender = if @queries then app.session.updateInputs else immediateRender

    doRender.call app.session, [], @queries or [], =>
      view.inputs  = @inputs  if @inputs
      view.queries = @queries if @queries

      $(@el).html view.render().el

# A function which is used to render the subview if the subview does not need
# to fetch any queries.
#
# Acts as a stub for app.session.updateInputs
#
immediateRender = (ignore..., callback) -> callback()
