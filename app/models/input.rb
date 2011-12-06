# An input is the canonical representation of an Input on ETengine; it defines
# the minimum, and maximum values to which the input may be set. These values
# should match those on ETengine except in cases where we want to alter them
# to better suit ETflex users.
#
# In most cases, however, the values in Input should be left alone, and custom
# input values should be set on a scene-by-scene basis using SceneInput
# instances instead.
#
class Input
  include Mongoid::Document

  # FIELDS -------------------------------------------------------------------

  # Both key and remote ID should match the "key" column - and primary key -
  # of the inputs on ETengine.

  identity              type: Integer
  field :key,           type: String

  # Values derived from ETengine, but may be customised if required.

  field :step,          type: Float,    default:   1.0
  field :min,           type: Float,    default:   0.0
  field :max,           type: Float,    default: 100.0
  field :start,         type: Float,    default: -> { min }
  field :unit,          type: String

  # Indices.

  index :key,           unique: true

  # VALIDATION ---------------------------------------------------------------

  validates :_id,       presence: true, uniqueness: true
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

end
