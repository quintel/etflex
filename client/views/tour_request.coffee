{ OverlayMessageView } = require('views/overlay_message')

class exports.TourRequestView extends OverlayMessageView
  handleAction: (event) ->
    super

    if $(event.target).data('action-key') is 'tour'
      require('views/tour').start()

  hide: (event) =>
    super

    # Don't show the tour request again.
    localStorage?.setItem 'seen-tour', require('app').user.id
