module Props
  # A Prop which is displayed as a bar graph with two bars. Each bar has a
  # source "query" with the value displayed on the bar, and an "extent" which
  # defines the maximum value displayed on the bar.
  #
  class DualBarGraph < Prop

    # FIELDS -----------------------------------------------------------------

    field :left_query_id,  type: Integer
    field :right_query_id, type: Integer

    field :left_extent,    type: Float
    field :right_extent,   type: Float

    # VALIDATION -------------------------------------------------------------

    validates :left_query_id,  presence: true
    validates :right_query_id, presence: true

    validates :left_extent,    presence: true, numericality: true
    validates :right_extent,   presence: true, numericality: true

  end # DualBarGraph
end # Props
