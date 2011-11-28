# State defines the way in which a prop changes depending on the value of a
# query.
#
# Icon props use them to define the values at which the icon will change from
# one image to another, and Gauge props use them to show different labels
# beneath the gauge depending on the query value.
#
# The state contains the lowest value at which the icon will transition into
# this state. For example, assuming an icon has the following states:
#
#   +-------------+-------+
#   |  State Name | Value |
#   +-------------+-------+
#   |         low | 50    |
#   |      medium | 100   |
#   |        high | 150   |
#   |     extreme | 200   |
#   +-------------+-------+
#
# ... here are some sample query results, and the currently active "state"
# based on that result:
#
#   +-----------------------+--------------+
#   |      Query Values     | Active State |
#   +-----------------------+--------------+
#   | -Infinity to 99       | low          |
#   |       100 to 149      | medium       |
#   |       150 to 199      | high         |
#   |       200 to Infinity | extreme      |
#   +-----------------------+--------------+
#
# Note that the lowest-value state is special in that it's minimum value is
# ignored and will include all values from -Infinity up to the minimum value
# of the second state.
#
class Props::State < ActiveRecord::Base

  set_table_name :prop_states

  # RELATIONS ----------------------------------------------------------------

  belongs_to :prop, polymorphic: true

  # VALIDATION ---------------------------------------------------------------

  validates :key,   presence: true
  validates :value, presence: true, numericality: true

end
