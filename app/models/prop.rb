# Defines a Prop (an output element) which provides visual feedback to the
# user as they change inputs.
#
# The behaviour of each prop is defined in a CoffeeScript class, but a
# database row is required for easier creation of scenes in the backstage UI.
#
# == Columns
#
# behaviour (String[1..100])
#   A "key" which identifies the CoffeeScript class used by prop. These are
#   defined in config/prop_map.yml. This is different to "key" in that it does
#   not need to be unique; it is acceptable for multiple props to use the same
#   CoffeeScript behaviour.
#
# key (String[1..100])
#   A unique key which identifies this prop when looking up I18n translations,
#   or when referring to the prop in UI code. You may leave this blank and it
#   will default to an underscored version of the behaviour attribute.
#
class Prop < ActiveRecord::Base

  attr_accessible :behaviour, :key

  # VALIDATION ---------------------------------------------------------------

  validates :key,       presence: true, length: { in: 1..100 }
  validates :behaviour, presence: true, length: { in: 1..100 }

  # BEHAVIOUR ----------------------------------------------------------------

  default_value_for(:key) { |p| p.behaviour and p.behaviour.underscore }

end
