# Defines a Prop (an output element) which provides visual feedback to the
# user as they change inputs, and query results are returned.
#
# The bahaviour of each prop is defined in a CoffeeScript class, but a
# database row is required for each to make is easier to edit scenes.
#
# == Column
#
# behaviour (String[1..100])
#   The unique "key" which identifies the CoffeeScript class for the prop.
#   These are defined in client/views/vis.coffee. This is different to "key"
#   in that it does not need to be unique; it is acceptable for multiple props
#   to use the same CoffeeScript behaviour.
#
# key (String[1..100])
#   A unique key which identifies this prop when looking up I18n translations,
#   etc. You may leave this blank and it will default to an underscored
#   version of behaviour.
#
class Prop < ActiveRecord::Base

  # VALIDATION ---------------------------------------------------------------

  validates :key,       presence: true, length: { in: 1..100 }
  validates :behaviour, presence: true, length: { in: 1..100 }

  # BEHAVIOUR ----------------------------------------------------------------

  default_value_for(:key) { |p| p.behaviour and p.behaviour.underscore }

end
