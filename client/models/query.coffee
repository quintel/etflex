# Represents a Query which is executed by ETengine (known there as a Gquery).
#
# ETflex worries only about the ID of the query, while `api::updateInputs`
# handles fetching new values for one or more Query instances when updating
# the user inputs.
#
# The usual "change:present" and "change:future" events will be fired when the
# computed Query results are updated.
#
class exports.Query extends Backbone.Model
