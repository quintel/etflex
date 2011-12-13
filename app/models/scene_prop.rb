# Relates a Scene to the props it uses. Provides the option to set a location
# so that the CoffeeScript view knows where to place the prop.
#
# == Columns
#
# location (String[1..50])
#   Determines where in the template the prop should be displayed. Each
#   template has a number of pre-defined locations where a prop is shown. For
#   example, the modern theme has a "center" location containing the supply /
#   demand graph, and a "bottom" location containing three icons.
#
class SceneProp < ActiveRecord::Base

  # RELATIONS ----------------------------------------------------------------

  belongs_to :scene
  belongs_to :prop

  # VALIDATION ---------------------------------------------------------------

  validates :scene_id, presence: true
  validates :prop_id,  presence: true
  validates :location, presence: true, length: { in: 1..50 }

end
