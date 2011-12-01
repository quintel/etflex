template = require 'templates/backstage/base'

# A base view for the Backstage section; sets up the main navigation element.
#
class exports.BaseView extends Backbone.View
  id: 'backstage'

  # Creates the HTML elements for the view, and binds events. Returns self.
  #
  # Example:
  #
  #   view = new BaseView
  #   $('body').html view.render().el
  #
  render: ->
    $(@el).html template()
    this
