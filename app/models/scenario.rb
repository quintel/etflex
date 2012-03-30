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

  attr_accessible :title, :guest_name, :input_values, :query_results,
                  :end_year, :country

  # SCOPES -------------------------------------------------------------------

  class << self
    # Returns the Scenario for a given scene ID, session ID pair, raising a
    # RecordNotFound error if no Scenario exists.
    #
    def for_session(scene_id, session_id)
      where(scene_id: scene_id, session_id: session_id).first
    end

    # Returns only scenarios which have either a guest name, or belong to a
    # registered user who has set their name.
    #
    # LEFT JOIN is required as Rails defaults to an INNER JOIN which excludes
    # all scenarios which do not have a user_id set.
    #
    def identified
      joins('LEFT JOIN `users` ON `users`.`id` = `scenarios`.`user_id`').
        where('`scenarios`.`guest_name` IS NOT NULL OR ' \
              '`users`.`name` IS NOT NULL')
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

    # Returns scenarios which were updated on or after the given time.
    #
    # time - A Time or Date object. Scenarios which haven't been updated since
    #        the time will be excluded from the returned collection.
    #
    # Raises an ArgumentError if time is nil.
    #
    def since(time)
      unless time.acts_like?(:time) or time.acts_like?(:date)
        raise ArgumentError, 'time must not be nil'
      end

      where 'updated_at > ?', time
    end

    # Selects the scenarios from the last 24 hours only
    #
    def last_24hours
      since 1.days.ago
    end

    # Selects the scenarios from last week only
    #
    def last_week
      since 7.days.ago
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

  # Returns the user if present, otherwise returns a Guest.
  #
  def user_or_guest
    user or Guest.new
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
    user_name = if user.present? then user.name else nil end
    user_name = guest_name unless user_name.present?

    { session_id:          session_id,
      href:               "/scenes/#{ scene_id }/with/#{ session_id }",
      score:               score,
      renewability:        renewability,
      total_costs:         total_costs,
      total_co2_emissions: total_co2_emissions,
      updated_at:          updated_at,
      user_id:             user_id || guest_uid,
      user_name:           user_name,
      profile_image:       user_or_guest.image_url }
  end

end
