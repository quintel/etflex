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

  # RELATIONS ----------------------------------------------------------------

  embeds_many :scene_inputs
  embeds_many :scene_props

  # INSTANCE METHODS ---------------------------------------------------------

  # Given a SceneInput, returns the Input instance it relates to.
  #
  # This method is preferred over using `scene.scene_input.input` since it
  # will eager load all of the inputs used by the scene so that we don't
  # perform a query for every input we want.
  #
  # @param [SceneInput] scene_input
  #   A SceneInput instance. This should be a SceneInput from the Scene's
  #   embedded `scene_inputs` collection.
  #
  # @return [Input]
  #   Returns the Input to which the SceneInput refers.
  # @return [nil]
  #   Returns nil if the Input does not exist, or the method was called with
  #   nil or a SceneInput which doesn't yet have a `input_id` value.
  #
  def input(scene_input)
    return nil if scene_input.nil? or scene_input.input_id.nil?

    unless @inputs_cache
      input_ids = scene_inputs.map(&:input_id).uniq
      inputs    = Input.any_of(:_id.in => input_ids)

      @inputs_cache = inputs.index_by(&:id)
    end

    @inputs_cache[ scene_input.input_id ]
  end

  # Given a SceneProp, returns the Prop instance it relates to.
  #
  # This method is preferred over using `scene.scene_prop.prop` since it will
  # eager load all of the props used by the scene so that we don't perform
  # a query for every prop we want.
  #
  # @param [SceneProp] scene_prop
  #   A SceneProp instance. This should be a SceneProp from the Scene's
  #   embedded `scene_props` collection.
  #
  # @return [Prop]
  #   Returns the Prop to which the SceneProp refers.
  # @return [nil]
  #   Returns nil if the Prop does not exist, or the method was called with
  #   nil or a SceneProp which doesn't yet have a `prop_id` value.
  #
  def prop(scene_prop)
    return nil if scene_prop.nil? or scene_prop.prop_id.nil?

    unless @props_cache
      prop_ids = scene_props.map(&:prop_id).uniq
      props    = Props::Base.any_of(:_id.in => prop_ids)

      @props_cache = props.index_by(&:id)
    end

    @props_cache[ scene_prop.prop_id ]
  end

end
