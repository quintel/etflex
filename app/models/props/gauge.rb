class Props::Gauge < ActiveRecord::Base

  # RELATIONS ----------------------------------------------------------------

  has_many :states, class_name: 'Props::State', as: :prop

  # VALIDATION ---------------------------------------------------------------

  validates :query_id, presence: true
  validates :min,      presence: true, numericality: true
  validates :max,      presence: true, numericality: true

end
