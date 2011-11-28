module Props
  # A Gauge is a prop which moves a needle left and right depending on a query
  # value. The gauge needs to know the query whose value should be used, and
  # the value represented at the far left, and far right, of the gauge.
  #
  # An example is the "supply too high" / "supply too low" gauge used on the 
  # ETlite recreation scene.
  #
  class Gauge < Prop

    # FIELDS -----------------------------------------------------------------

    field :query_key, type: String

    field :min,       type: Float
    field :max,       type: Float

    # Icon transitions between different states depending on the query value.
    embeds_many :states, class_name: 'Props::State', as: :stateful

    # VALIDATION -------------------------------------------------------------

    validates :query_key, presence: true
    validates :min,       presence: true, numericality: true
    validates :max,       presence: true, numericality: true

  end # Gauge
end # Props
