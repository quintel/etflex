# Brings together Inputs and Props to create a "Scene" with which users may
# interact. An example is the ETlite scene which provides a range of energy-
# saving and power-generation options, and shows the user the effect of their
# choices on supply and demand, and CO2 emissions, etc.
#
# TODO Validate that either name or name_key are set.
#
class Scene
  include Mongoid::Document

  # FIELDS -------------------------------------------------------------------

  # A human readable name for the Scene. Useful for when visitors create their
  # own Scenes; they can't - and won't want to - set localised strings in each
  # language.
  #
  # Staff should leave this blank, set a "name_key" instead, and be sure to
  # set the I18n strings from which the Scene name will be derived.

  field :name, type: String

  # "name_key" allows staff to omit a Scene name (since it would be limited
  # to one language) and provides the option of using an I18n key instead.

  field :name_key, type: String

  # VALIDATION ---------------------------------------------------------------

  validates_presence_of :name, if: -> { name_key.blank? }
  validates_length_of   :name, maximum: 100

end
