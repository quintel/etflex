# SceneInputs are embedded within a Scene document and link a scene to the
# Inputs it uses. SceneInputs may also customise the values from Input so that
# each scene may have it's own min, max, start, and step values for each
# input.
class SceneInput
  include Mongoid::Document
  include Mongoid::List

  # FIELDS -------------------------------------------------------------------

  delegate :remote_id, :key, :step, :unit, to: :input, allow_nil: true

  # Determines if this Input is displayed in the left or right group.

  field :left, type: Boolean, default: true

  # Custom Input values. When these are nil, the values from the Input will
  # be used instead.

  field :min,   type: Float
  field :max,   type: Float
  field :start, type: Float

  # Customise Mongoid::List to scope to the "left" value.

  field :position, type: Integer, scope: 'left'

  # VALIDATION ---------------------------------------------------------------

  validates :input_id, presence: true

  # RELATIONS ----------------------------------------------------------------

  embedded_in :scene, inverse_of: :scene_inputs
  belongs_to :input

  # INSTANCE METHODS ---------------------------------------------------------

  # Returns if this input should be shown on the right-hand side of the
  # scene page.
  #
  def right?
    not left?
  end

  # Retrieves the minimum value to which the input may be set in the scene. If
  # no value is set, the value from the canonical input will be used instead.
  #
  # @return [Float]
  #   Returns the minimum value, or the associated input minimum.
  #
  def min
    read_attribute(:min) or ( input and input.min )
  end

  # Retrieves the maximum value to which the input may be set in the scene. If
  # no value is set, the value from the canonical input will be used instead.
  #
  # @return [Float]
  #   Returns the maximum value, or the associated input maximum.
  #
  def max
    read_attribute(:max) or ( input and input.max )
  end

  # Retrieves the starting value to which the input may be set in the scene.
  # If no value is set, the value from the canonical input will be used
  # instead.
  #
  # @return [Float]
  #   Returns the start value, or the associated input start value.
  #
  def start
    read_attribute(:start) or ( input and input.start )
  end

  alias mongoid_input input

  # Overwrites the default #input accessor to try to call Scene#input.
  #
  # Since we often want to fetch the related input for all of the Inputs used
  # by a Scene, we delegate to Scene#input where possible so that _all_ of the
  # inputs can be eager loaded in one query, instead of every SceneInput
  # hitting the database separately.
  #
  # If no Scene is set, this will fall back to the standard Mongoid #input
  # accessor.
  #
  # @return [Input] Returns the related Input record.
  # @return [nil]   Returns nil if no Input is related.
  #
  def input(reload = false, *args)
    if not reload and input_id.present? and scene.present?
      scene.input(self)
    else
      mongoid_input(reload, *args)
    end
  end

end
