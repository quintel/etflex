# Scenario keeps track of a users attempt to complete a scene. Holding on to
# the scene ID, user ID, and the corresponding ETengine session ID, it allows
# a user to attempt a scene more than once times, and to share each scene with
# other visitors.
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
#   The ETengine session ID which was used when completing the scene.
#
# input_values (Hash)
#   A copy of the input values chosen by the user.
#
# query_results (Hash)
#   A cached copy of the query results returned by the most recent ETengine
#   request for this scene. Used to rank scenarios, and enables "local-start"
#   in the client.
#
# guest_uid (String), guest_name (String)
#   Used instead of user_id when the scenario belongs to an unregistered
#   visitor containing a unique ID and optional user name.
#
class Scenario < ActiveRecord::Base

  serialize :input_values,  Hash
  serialize :query_results, Hash

  attr_accessible :title, :guest_name, :input_values, :query_results,
                  :end_year, :country

  # SCOPES -------------------------------------------------------------------

  default_scope include: :scene, joins: :scene

  # Returns the Scenario for a given scene ID / session ID pair.
  def self.for_session(scene_id, session_id)
    where(scene_id: scene_id, session_id: session_id).first
  end

  # Returns only scenarios which have either a guest name, or belong to a
  # registered user who has set their name.
  #
  # LEFT JOIN is required: Rails defaults to an INNER JOIN which excludes
  # all scenarios which have no user_id set.
  #
  scope :identified, lambda {
    joins('LEFT JOIN `users` ON `users`.`id` = `scenarios`.`user_id`').
      where('`scenarios`.`guest_name` IS NOT NULL OR ' \
            '`users`.`name` IS NOT NULL')
  }

  # Returns scenarios belonging to the given user or guest. Handy when
  # chained on to a scene, for example:
  #
  #   scene.scenarios.for_user(user).recent
  #
  # user - A User or Guest whose scenarios are to be retrieved.
  #
  scope :for_user, lambda { |user| where user_attribute_for(user) => user.id }

  # Returns scenarios which do not belong to the given user or guest. Useful
  # if chained onto a scene, for example:
  #
  #   scene.scenarios.for_users_other_than(user).recent
  #
  # user - A User or Guest whose scenarios should not be included in those
  #        retrieved from the DB.
  #
  scope :for_users_other_than, lambda { |user|
    attribute = user_attribute_for user

    where [ "#{attribute} != ? OR #{attribute} IS NULL", user.id ]
  }

  # Orders the retrieved scenarios from newest to oldest.
  scope :recent, order('updated_at DESC')

  # Returns scenarios updated at -- or after -- the given time.
  #
  # time - A Time or Date object.
  #
  # Raises an ArgumentError if time is nil.
  #
  scope :since, lambda { |time|
    unless time.acts_like?(:time) or time.acts_like?(:date)
      raise ArgumentError, 'time must not be nil'
    end

    where 'updated_at > ?', time
  }

  # Returns scenarios belonging to a certain scene.
  #
  # scene - An instance of `Scene`
  #
  scope :for_scene, lambda { |scene| where [ "scene_id = ?", scene.id ] }

  # Returns scenarios suitable for display in the high scores list.
  #
  # time - A Time or Date object. Scenarios which haven't been updated since
  #        "time" will be excluded from the returned collection.
  #
  # Raises an ArgumentError if time is nil.
  #
  scope :high_scores_since, lambda { |time|
    since(time).identified.by_score.
      # We need to select twice as many scenarios as are actually displayed;
      # if a scenario currently in the top five is demoted, we need the next
      # highest so that it can be promoted in the UI. So, twice as many
      # allows all of the top five to be demoted without the UI crapping
      # out.
      #
      # In the real world, (number_shown) + 2 *should* be enough...
      #
      limit(20)
  }

  # Selects the scenarios from the last 24 hours only
  scope :last_24hours, lambda { since 1.days.ago }

  # Selects the scenarios from last week only
  scope :last_week, lambda { since 7.days.ago }

  # Orders the retrieved scenarios by score from highest to lowest.
  scope :by_score, lambda { order('score DESC') }

  # RELATIONSHIPS ------------------------------------------------------------

  belongs_to :user
  belongs_to :scene

  # VALIDATION ---------------------------------------------------------------

  validates :user_id,    presence: true, if: -> { guest_uid.blank? }
  validates :scene_id,   presence: true
  validates :session_id, presence: true, uniqueness: true

  # INSTANCE METHODS ---------------------------------------------------------

  # Use the ETEngine session as the URL parameter.
  def to_param
    session_id
  end

  # Returns the user if present, otherwise returns a Guest.
  def user_or_guest
    user or Guest.new(guest_uid, guest_name)
  end

  # Determines if the given user or guest is allowed to change this scenario.
  #
  # visitor - A User or Guest instance to check.
  #
  def can_change?(visitor)
    if new_record?
      true
    elsif self.user_id.present?
      visitor.kind_of?(User) && visitor.id == user_id
    elsif self.guest_uid.present?
      visitor.kind_of?(Guest) && visitor.id == guest_uid
    else
      false
    end
  end

  # Writes the input values hash. When given nil will always set an empty
  # hash, converting the hash keys to integers.
  #
  # values - A hash of input IDs and the value the user set.
  #
  def input_values=(values)
    write_attribute(:input_values,
      (values || {}).each_with_object(Hash.new) do |(key, value), obj|
        obj[ (key.to_s rescue key) || key ] = value
      end)
  end

  # Writes the query results hash. Will set an empty hash if given nil. If the
  # "score" query is present, it's value will be copied into the score column;
  # otherwise the score column will be set to nil.
  #
  # results - A hash of query keys and the value returned by ETEngine.
  #
  def query_results=(results)
    write_attribute(:query_results, results.present? ? results.to_hash : {})
    self.score               = query_results[self.scene.score_gquery]
    self.total_co2_emissions = query_results['total_co2_emissions']
    self.total_costs         = query_results['total_costs']
    self.renewability        = query_results['renewability']
  end

  # Returns a copy of the scenario as a hash containing data which it sent to
  # Pusher when the scenario is created or updated.
  #
  # TODO This should be a JBuilder template so we have access to URL helpers.
  #
  def to_pusher_event
    user_name = if user.present? then user.name else nil end
    user_name = guest_name unless user_name.present?

    { session_id:          session_id,
      href:               "/scenes/#{ scene_id }/with/#{ session_id }",
      score:               score,
      updated_at:          updated_at,
      user_id:             user_id || guest_uid,
      user_name:           user_or_guest.name,
      profile_image:       user_or_guest.image_url }
  end

  #######
  private
  #######

  # Guests and Users are stored differently in a Scenario; returns the
  # column used to store the unique visitor ID for this scenario.
  #
  # Raises an error when "visitor" is not a User or Guest.
  def self.user_attribute_for(visitor)
    case visitor
    when User  then :user_id
    when Guest then :guest_uid
    else raise 'Scenario.user_attribute_for requires a User or Guest'
    end
  end
end
