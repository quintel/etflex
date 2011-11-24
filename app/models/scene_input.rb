class SceneInput < ActiveRecord::Base

  delegate :remote_id, :key, :step, :unit, to: :input

  # RELATIONSHIPS ------------------------------------------------------------

  belongs_to :scene
  belongs_to :input

  # VALIDATION ---------------------------------------------------------------

  validates :scene_id, presence: true
  validates :input_id, presence: true

  # BEHAVIOUR ----------------------------------------------------------------

  acts_as_list scope: [ :scene_id, :placement ]

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

end
