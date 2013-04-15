groupTempl      = require 'templates/group'
{ showMessage } = require 'lib/messages'

class exports.GroupView extends Backbone.View
  events:
    'click .help': 'showHelp'

  constructor: ->
    super
    @groupName = I18n.t "groups.#{@model}"
    @hasInfo   = I18n.lookup("groups.information.#{@model}")?

  renderInto: (destination) ->
    @$el.html groupTempl(group: @groupName, hasInfo: @hasInfo)
    destination.append @$el

    @delegateEvents()

  showHelp: ->
    showMessage @groupName, I18n.t "groups.information.#{@model}"
