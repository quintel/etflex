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

  attr_accessible :title, :input_values, :query_results, :end_year, :country

  # SCOPES -------------------------------------------------------------------

  class << self
    # Returns the Scenario for a given scene ID, session ID pair, raising a
    # RecordNotFound error if no Scenario exists.
    #
    def for_session(scene_id, session_id)
      where(scene_id: scene_id, session_id: session_id).first
    end

    # Returns scenarios which belong to the given user or guest. Handy when
    # chained onto a scene, for example:
    #
    #   scene.scenarios.for_user(user).recent
    #
    # user - A User or Guest whose scenarios are to be retrieved.
    #
    def for_user(user)
      where user_attribute_for(user) => user.id
    end

    # Returns scenarios which do not belong to the given user or guest. Useful
    # if chained onto a scene, for example:
    #
    #   scene.scenarios.for_users_other_than(user).recent
    #
    # user - A User or Guest whose scenarios should not be included in those
    #        retrieved from the DB.
    #
    def for_users_other_than(user)
      attribute = user_attribute_for user

      where [ "#{attribute} != ? OR #{attribute} IS NULL", user.id ]
    end

    # Orders the retrieved scenarios from newest to oldest.
    #
    def recent
      order 'updated_at DESC'
    end

    # Orders the retrieved scenarios by score from highest to lowest.
    #
    def by_score
      order 'score DESC'
    end

    #######
    private
    #######

    # Returns the column used to look up a given object (a User or Guest)
    #
    # Returns :user_id or :guest_id depending on the type of object given.
    #
    def user_attribute_for(thing)
      case thing
        when User  then :user_id
        when Guest then :guest_uid
        else raise 'Scenario.user_attribute_for requires a User or Guest'
      end
    end
  end # class << self

  # RELATIONSHIPS ------------------------------------------------------------

  belongs_to :user
  belongs_to :scene

  # VALIDATION ---------------------------------------------------------------

  validates :user_id,    presence: true, if: -> { guest_uid.blank? }
  validates :scene_id,   presence: true
  validates :session_id, presence: true, uniqueness: true

  # INSTANCE METHODS ---------------------------------------------------------

  # Use the ETEngine session as the URL parameter.
  #
  def to_param
    session_id
  end

  # Determines if a given user or guest is permitted to change this scenario.
  #
  # check - A User or Guest instance to check.
  #
  def can_change?(check)
    if new_record?
      true
    elsif self.user_id.present?
      check.kind_of?(User) && check.id == user_id
    elsif self.guest_uid.present?
      check.kind_of?(Guest) && check.id == guest_uid
    else
      false
    end
  end

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
    self.score               = query_results['etflex_score']
    self.total_co2_emissions = query_results['total_co2_emissions']
    self.total_costs         = query_results['total_costs']
    self.renewability        = query_results['renewability']
  end

  # Returns a copy of the scenario as a hash containing data which should be
  # sent to Pusher whenever the scenario is created or updated.
  #
  # TODO This should be a JBuilder template so we have access to URL helpers.
  #
  def to_pusher_event
    { session_id:          session_id,
      href:               "/scenes/#{ scene_id }/with/#{ session_id }",
      score:               score,
      renewability:        renewability,
      total_costs:         total_costs,
      total_co2_emissions: total_co2_emissions,
      updated_at:          updated_at,
      profile_image:     ( user or Guest.new ).image_url }
  end

end
