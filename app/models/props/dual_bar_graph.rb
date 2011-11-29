module Props
  # A Prop which is displayed as a bar graph with two bars. Each bar has a
  # source "query" with the value displayed on the bar, and an "extent" which
  # defines the maximum value displayed on the bar.
  #
  class DualBarGraph < Base

    # FIELDS -----------------------------------------------------------------

    field :left_query_key,  type: String
    field :right_query_key, type: String

    field :left_extent,     type: Float
    field :right_extent,    type: Float

    # VALIDATION -------------------------------------------------------------

    validates :left_query_key,  presence: true
    validates :right_query_key, presence: true

    validates :left_extent,     presence: true, numericality: true
    validates :right_extent,    presence: true, numericality: true

  end # DualBarGraph
end # Props
