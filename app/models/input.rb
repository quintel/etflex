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
#   The ID of the input on ETengine. The Backbone client requires this so that
#   it can tell ETengine whenever the user updates the input.
#
# key (String[1..255])
#   A unique string key which identifies this input. Used when looking up I18n
#   translations, and should probably match the key on ETengine.
#
# step (Float)
#   When the input is a slider, "step" determines the increments in which the
#   user can move the slider handle. Steps of 0.1 will allow the slider to be
#   moved from 0.0, to 0.1, to 0.2, etc.
#
# min (Float)
#   The minimum acceptable value for the slider. Generally speaking this
#   should match the minimum value on ETengine, but may be customised where
#   necessary. It should not be lower than the ETengine value.
#
# max (Float)
#   The maximum acceptable value for the slider. Generally speaking this
#   should match the maximum value on ETengine, but may be customised where
#   necessary. It should not be higher than the ETengine value.
#
# start (Float)
#   The default value of the input before the user makes any changes.
#
# unit (String[1..255])
#   A text suffix used when showing the user the value of the input. A unit of
#   "MW" will result in the input value being formatted as "1,500 MW", etc.
#
class Input < ActiveRecord::Base

  # VALIDATION ---------------------------------------------------------------

  validates :remote_id, presence: true, uniqueness: true, on: :create
  validates :key,       presence: true, uniqueness: true

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

end
