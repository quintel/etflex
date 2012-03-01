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
# group (String[1..50])
#   A group to which the input belongs; sliders which belong to a group need
#   to be balanced so that the cumulative value of all inputs in the group sum
#   to 100.
#
class Input < ActiveRecord::Base

  def acts_like_input? ; true end

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

  # CLASS METHODS ------------------------------------------------------------

  # Given one or more inputs, returns all of the inputs which are related to
  # them by the "group" column. The sliders passed in to the method will not
  # be included in those returned.
  #
  # inputs - The input, or collection of inputs, whose siblings are to be
  #          retrieved. This may be an Input, SceneInput, or an array
  #          containing multiple inputs or scene inputs.
  #
  def self.siblings(inputs)
    inputs = if inputs.acts_like?(:input) then [ inputs ] else inputs.dup end
    inputs.reject! { |input| input.group.blank? }

    return [] if inputs.empty?

    groups, exclusions =
      inputs.each_with_object([ Set.new, Set.new ]) do |input, (gr, ex)|
        gr.add(input.group)
        ex.add(input.remote_id)
      end

    siblings = Input.where(group: groups.to_a)
    siblings.reject { |input| exclusions.include?(input.remote_id) }
  end

  # Given one or more inputs, returns all of the inputs which are related to
  # them by the "group" column. The inputs passed in to the method will not
  # be included in those returned.
  #
  # If, of the sliders passed in, there are two or more which are already in
  # the same group, none of the groups siblings will be included. This
  # happens so that client-side balancing only happens on sliders which the
  # user can see.
  #
  # inputs - The input, or collection of inputs, whose siblings are to be
  #          retrieved. This may be an Input, SceneInput, or an array
  #          containing multiple inputs or scene inputs.
  #
  def self.dependent_siblings(inputs)
    groups_with_multiples =
      inputs.group_by(&:group).map do |group, inputs|
        if inputs.count > 1 then group else nil end
      end

    siblings(inputs).reject do |input|
      groups_with_multiples.include? input.group
    end
  end

end
