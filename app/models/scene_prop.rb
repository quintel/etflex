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

end
