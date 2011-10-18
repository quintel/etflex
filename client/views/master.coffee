# A Singleton master view which delegates rendering of individual pages to
# sub-views (such as the ETlite recreation, etc).
#
# The `Master` view is initialized during the boot and stored on
# `app.masterView`.
#
class exports.Master extends Backbone.View
  el: '#chrome'

  # The currently rendered sub-view, or null if the page is still being
  # loaded.
  currentView: null

  # Given a new `View` instance, destructs the current sub-view, then renders
  # the new view and replaces the page contents with it.
  #
  # view - The new view to be rendered and added to the page.
  #
  setSubView: (view) ->
    @currentView?.destruct?()
    @currentView = view

    $(@el).html view.render().el
