# SceneProp acts as a join model which links a Scene with the Props it uses.
#
# It simplifies the use of props polymorphically (so that Scene doesn't care
# what class defines a Prop). It also allows us to add extra attributes, such
# as defining where in the scene the prop should be shown, e.g. in the center
# between the sliders, at the bottom, in the header, etc.
#
class SceneProp < ActiveRecord::Base

  # RELATIONS ----------------------------------------------------------------

  belongs_to :scene
  belongs_to :prop, polymorphic: true

  # VALIDATION ---------------------------------------------------------------

  validates :scene_id,  presence: true
  validates :prop_id,   presence: true
  validates :prop_type, presence: true

end
