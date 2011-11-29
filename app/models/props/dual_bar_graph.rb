class Props::DualBarGraph < ActiveRecord::Base

  # VALIDATION ---------------------------------------------------------------

  validates :left_extent,  presence: true, numericality: true
  validates :right_extent, presence: true, numericality: true

end
