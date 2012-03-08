# Creates an HTML tag showing the given time in the user's locale.
#
# Formatted so that the time is shown relative to the current time (a few
# seconds ago, 2 days ago, etc). Recent times are refreshed every 60 seconds.
#
# The given time may be any format accepted by the Moment library; a JS Date,
# Unix second-since-epoch, string, etc.
#
exports.relativeTime = (date) ->
  date     = moment date

  json     = date.format 'YYYY-MM-DDTHH:mm:ssZZ'
  readable = date.format 'LLL'
  relative = date.fromNow()

  "<time class=\"js-relative-date\"
     datetime=\"#{ json }\" title=\"#{ readable }\">#{ relative }</time>"
