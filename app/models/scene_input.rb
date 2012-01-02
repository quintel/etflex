# Scene inputs relate Scenes to the inputs they use. As a join model,
# SceneInput allows customising the minimum, maximum, and starting values of
# the input.
#
# == Columns
#
# scene_id (Integer)
#   Foreign key relating the scene input to it's parent scene.
#
# input_id (Integer)
#   Foreign key relating the scene to the input.
#
# location (String[1.100])
#   Determines where in the template the input should be displayed. Each
#   template will have a range of places in which inputs may appear; the
#   modern theme, for example, has "left" and "right".
#
# position (Integer)
#   Used by acts_as_list to order inputs in the "left" or "right" slider
#   groups.
#
# step (Float)
#   When the input is a slider, "step" determines the increments in which the
#   user can move the slider handle. Steps of 0.1 will allow the slider to be
#   moved from 0.0, to 0.1, to 0.2, etc. Left blank, the scene will use the
#   step value defined in the Input.
#
# min (Float)
#   Allows you to customise the minimum value of the slider as it appears in
#   the scene, without having to edit the Input (which would affect all
#   scenes). Left blank, the scene will use the minimum value defined in the
#   Input.
#
# max (Float)
#   Allows you to customise the maximum value of the slider as it appears in
#   the scene, without having to edit the Input (which would affect all
#   scenes). Left blank, the scene will use the maximum value defined in the
#   Input.
#
# start (Float)
#   Allows you to customise the start value of the slider as it appears in
#   the scene, without having to edit the Input (which would affect all
#   scenes). Left blank, the scene will use the starting value defined in the
#   Input.
#
# information_en (String)
#   English text containing information about the input and how it will affect
#   the scene outcome.
#
# information_nl (String)
#   Dutch text containing information about the input and how it will affect
#   the scene outcome.
#
class SceneInput < ActiveRecord::Base

  delegate :key, :unit, to: :input, allow_nil: true

  attr_accessible :input, :input_id, :location, :position, :step, :min, :max,
                  :step, :start, :information_en, :information_nl

  # VALIDATION ---------------------------------------------------------------

  validates :location, presence: true
  validates :scene_id, presence: true
  validates :input_id, presence: true, uniqueness: { scope: :scene_id }

  # Ensure that the minimum value does not exceed the minimum value defined in
  # the Input; but only if the input is set, and has a minimum.
  #
  validates_numericality_of :min,
    greater_than_or_equal_to: ->(si) { si.input.min },
    if:                       ->(si) { si.input and si.input.min.present? }

  # Ensure that the maximum value does not exceed the maximum value defined in
  # the Input; but only if the input is set, and has a maximum.
  #
  validates_numericality_of :max,
    less_than_or_equal_to:    ->(si) { si.input.max },
    if:                       ->(si) { si.input and si.input.max.present? }

  # RELATIONSHIPS ------------------------------------------------------------

  belongs_to :scene
  belongs_to :input

  # BEHAVIOUR ----------------------------------------------------------------

  acts_as_list scope: [ :scene_id, :location ]

  # INSTANCE METHODS ---------------------------------------------------------

  # Retrieves the step value to which the input may be set in the scene. If no
  # value is set, the value from the canonical input will be used instead.
  #
  # @return [Float]
  #   Returns the step value, or the associated input step.
  #
  def step
    read_attribute(:step) or ( input and input.step )
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

  # Returns the ID of the input on ETEngine; this is stored simply as the
  # identity field for the Input.
  #
  # @return [Integer]
  #   Returns the ID of the input on ETEngine.
  #
  def remote_id
    input and input.remote_id
  end

end
