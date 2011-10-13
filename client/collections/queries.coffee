# Contains all of the Queries which ETflex needs to know about. Note that
# computed query results may not _always_ be up-to-date. For example, if the
# user is on a Solar Energy page, moving inputs will result in the queries
# _for that page_ being updated.
#
# Other queries, which may still have been affected by the users change will
# not have been automatically updated (since doing so would require ETengine
# to recalculate every query, every time the user changed a value).
#
class exports.Queries extends Backbone.Collection
  model: require('models/query').Query
