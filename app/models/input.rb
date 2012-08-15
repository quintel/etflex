# An input is the canonical representation of an Input on ETengine; it defines
# the minimum, and maximum values to which the input may be set. These values
# should match those on ETengine except in cases where we want to alter them
# to better suit ETflex users.
#
# In most cases, however, the values in Input should be left alone, and custom
# input values should be set on a scene-by-scene basis using SceneInput
# instances instead.
#
# == Columns
#
# remote_id (Integer)
#   The ID of the input on ETengine. Required by the Backbone client so that
#   it can tell ETengine when the user updates the input.
#
# key (String[1..255])
#   A unique  key which identifies this input. Used when looking up I18n
#   translations, and should probably match the key on ETengine.
#
# step (Float)
#   When the input is a slider, "step" determines the increments in which the
#   user can move the slider handle. Steps of 0.1 will allow the slider to be
#   moved from 0.0, to 0.1, to 0.2, etc.
#
# min (Float)
#   The minimum acceptable input value. It should match the ETengine value but
#   may be customised to a higher value.
#
# max (Float)
#   The minimum acceptable input value. It should match the ETengine value but
#   may be customised to a lower value.
#
# start (Float)
#   The default value of the input before the user makes any changes.
#
# unit (String[1..255])
#   A text suffix used when showing the user the value of the input. For
#   example, a unit of "MW" results in the formated value "1,500 MW".
#
# group (String[1..50])
#   A group to which the input belongs; inputs in a group are balanced so that
#   their values sum to 100.
#
class Input < ActiveRecord::Base

  def acts_like_input? ; true end

  attr_accessible :remote_id, :key, :group, :min, :max, :start, :step, :unit

  # VALIDATION ---------------------------------------------------------------

  validates :remote_id, presence: true, uniqueness: true, on: :create
  validates :key,       presence: true, uniqueness: true

  validates :group,     length: { maximum: 50, allow_nil: true }

  validates :min,       presence: true, numericality: true
  validates :max,       presence: true, numericality: true
  validates :start,     presence: true, numericality: true
  validates :step,      presence: true, numericality: true

  validate :max, :validate_max_gte_min

  # Custom validation - ensures that the maximum value, if present, is at
  # least equal to the minimum value, if present.
  #
  def validate_max_gte_min
    if min.present? and max.present? and min > max
      errors.add(:max, :less_than_min)
    end
  end

  # BEHAVIOUR ----------------------------------------------------------------

  default_value_for(:start) { |input| input.min }

  # INSTANCE METHODS ---------------------------------------------------------

  def to_s
    key
  end

end
