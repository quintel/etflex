# An input is the canonical representation of an Input on ETengine; it defines
# the minimum, and maximum values to which the input may be set. These values
# should match those on ETengine except in cases where we want to alter them
# to better suit ETflex users.
#
# In most cases, however, the values in Input should be left alone, and custom
# input values should be set on a scene-by-scene basis using SceneInput
# instances instead.
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

  # BAHAVIOUR ----------------------------------------------------------------

  default_value_for(:start) { |input| input.min }

end
