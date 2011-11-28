class Props::DualBarGraph < ActiveRecord::Base

  set_table_name :dual_bar_graph_props

  # VALIDATION ---------------------------------------------------------------

  validates :left_extent,  presence: true, numericality: true
  validates :right_extent, presence: true, numericality: true

end
