# Scenario keeps track of a user's attempt to complete a scene. Holding on to
# the scene ID, user ID, and the corresponding ET-Engine session ID, it allows
# a user to attempt a scene multiple times, and to share their scenes with
# others.
#
# == Columns
#
# user_id (Integer)
#   Foreign key relating the scenario to the user who created it.
#
# scene_id (Integer)
#   Foreign key relating the scenario to the scene.
#
# session_id (Integer)
#   The ET-Engine session ID which was used when completing the scene.
#
class Scenario < ActiveRecord::Base

  # Returns the Scenario for a given scene ID, session ID pair, raising a
  # RecordNotFound error if no Scenario exists.
  #
  def self.for_session!(scene_id, session_id)
    where(scene_id: scene_id, session_id: session_id).first!
  end

  # RELATIONSHIPS ------------------------------------------------------------

  belongs_to :user
  belongs_to :scene

  # VALIDATION ---------------------------------------------------------------

  validates :user_id,    presence: true
  validates :scene_id,   presence: true
  validates :session_id, presence: true, uniqueness: true

end
