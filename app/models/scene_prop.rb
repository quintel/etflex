# Relates a Scene to the props it uses. Provides the option to set a location
# so that the CoffeeScript view knows where to place the prop.
#
# == Columns
#
# scene_id (Integer)
#   Foreign key relating the SceneProp to it's parent scene.
#
# prop_id (Integer)
#   Foreign key relating the SceneProp to the prop used by the scene.
#
# location (String[1..50])
#   Determines where in the template the prop should be displayed. Each
#   template has a number of pre-defined locations where a prop is shown. For
#   example, the modern theme has a "center" location containing the supply /
#   demand graph, and a "bottom" location containing three icons.
#
class SceneProp < ActiveRecord::Base
  extend ETFlex::ConcatenatedAttributes

  delegate :key, :behaviour, to: :prop, allow_nil: true

  concatenate_attr :hurdles, :to_f

  # RELATIONSHIPS ------------------------------------------------------------

  belongs_to :scene
  belongs_to :prop

  # SERIALIZATION ------------------------------------------------------------

  serialize :hurdles, Array

  # VALIDATION ---------------------------------------------------------------

  validates :scene_id, presence: true
  validates :prop_id,  presence: true
  validates :location, presence: true, length: { in: 1..50 }

end
