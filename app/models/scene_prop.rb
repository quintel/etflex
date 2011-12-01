class SceneProp
  include Mongoid::Document

  # FIELDS -------------------------------------------------------------------

  # Determines where in the template the prop should be displayed. Each
  # template has a number of pre-defined locations where a prop is shown. For
  # example, the modern theme has a "center" location containing the supply /
  # demand graph, and a "bottom" location containing three icons.

  field :location, type: String

  # RELATIONS ----------------------------------------------------------------

  embedded_in :scene
  belongs_to :prop, class_name: 'Props::Base'

  # VALIDATION ---------------------------------------------------------------

  validates :prop_id, presence: true

  # INSTANCE METHODS ---------------------------------------------------------

  alias mongoid_prop prop

  # Overwrites the default #prop accessor to try to call Scene#prop.
  #
  # Since we often want to fetch the related prop for all of the Props used
  # by a Scene, we delegate to Scene#prop where possible so that _all_ of the
  # props can be eager loaded in one query, instead of every SceneProp hitting
  # the database separately.
  #
  # If no Scene is set, this will fall back to the standard Mongoid #prop
  # accessor.
  #
  # @return [Prop] Returns the related Prop record.
  # @return [nil]  Returns nil if no Prop is related.
  #
  def prop(reload = false, *args)
    if not reload and prop_id.present? and scene.present?
      scene.prop(self)
    else
      mongoid_prop(reload, *args)
    end
  end

end
