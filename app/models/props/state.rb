module Props
  # The icon prop fades between different images based on a state, represented
  # by one or more IconState instances. These are embedded within the Icon
  # "states" collection. States are also embedded within Gauges allowing
  # developers to display a different label beneath the gauge as the valae
  # changes.
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
  # Note that the first state is special in that it's minimum value is ignored
  # and will include all values from -Infinity up to the minimum value of the
  # second state.
  #
  class State
    include Mongoid::Document

    # FIELDS -----------------------------------------------------------------

    field :key,   type: String
    field :value, type: Float

    # stateful=(Icon,Gauge)
    embedded_in :stateful, polymorphic: true

    # VALIDATION -------------------------------------------------------------

    validates :key,   presence: true
    validates :value, presence: true, numericality: true

  end # State
end # Props
