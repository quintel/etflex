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
#   Determines where in the template the prop should be displayed. e.g.
#   "left", "right", "dashboard".
#
# position (Integer)
#   Props which are have same location will be ordered by their "position"
#   value.
#
class SceneProp < ActiveRecord::Base

  delegate :key, :behaviour, to: :prop, allow_nil: true

  attr_accessible :location, :prop_id, :position

  default_scope do
    order(:position)
  end

  # RELATIONSHIPS ------------------------------------------------------------

  belongs_to :scene
  belongs_to :prop

  # VALIDATION ---------------------------------------------------------------

  validates :scene_id, presence: true
  validates :prop_id,  presence: true
  validates :location, presence: true, length: { in: 1..50 }

end
