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

  serialize :input_values,  Hash
  serialize :query_results, Hash

  # Returns the Scenario for a given scene ID, session ID pair, raising a
  # RecordNotFound error if no Scenario exists.
  #
  def self.for_session(scene_id, session_id)
    where(scene_id: scene_id, session_id: session_id).first
  end

  # RELATIONSHIPS ------------------------------------------------------------

  belongs_to :user
  belongs_to :scene

  # VALIDATION ---------------------------------------------------------------

  validates :user_id,    presence: true
  validates :scene_id,   presence: true
  validates :session_id, presence: true, uniqueness: true

  # INSTANCE METHODS ---------------------------------------------------------

  # Writes the input values hash. When given nil will always set an empty
  # hash, and converts the hash keys to integers.
  #
  # values - A hash of input IDs and the value the user set.
  #
  def input_values=(values)
    write_attribute(:input_values,
      (values || {}).each_with_object(Hash.new) do |(key, value), obj|
        obj[ (key.to_i rescue key) || key ] = value
      end)
  end

  # Writes the query results hash. When given nil will always set an empty
  # hash. If the "score" query is present, it's value will be copied into the
  # score column; otherwise the score column will be set to nil.
  #
  # results - A hash of query keys and the value returned by ETEngine.
  #
  def query_results=(results)
    write_attribute(:query_results, results.present? ? results.to_hash : {})
    self.score               = query_results['score']
    self.total_co2_emissions = query_results['total_co2_emissions']
    self.total_costs         = query_results['total_costs']
    self.renewability        = query_results['renewability']
  end

end
