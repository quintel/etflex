# Defines a Prop (an output element) which provides visual feedback to the
# user as they change inputs, and query results are returned.
#
# The bahaviour of each prop is defined in a CoffeeScript class, but a
# database row is required for each to make is easier to edit scenes.
#
# == Column
#
# client_key (String[1..100])
#   The unique "key" which identifies the CoffeeScript class for the prop.
#   These are defined in client/views/vis.coffee.
#
# key (String[1..100])
#   A unique key which identifies this prop when looking up I18n translations,
#   etc. You may leave this blank and it will default to an underscored
#   version of client_key.
#
class Prop < ActiveRecord::Base

  # VALIDATION ---------------------------------------------------------------

  validates :key,        presence: true, length: { in: 1..100 }
  validates :client_key, presence: true, length: { in: 1..100 }

  # BEHAVIOUR ----------------------------------------------------------------

  default_value_for(:key) { |p| p.client_key and p.client_key.underscore }

end
