class Input < ActiveRecord::Base

  # VALIDATION ---------------------------------------------------------------

  validates :key,       presence: true, uniqueness: true
  validates :remote_id, presence: true, uniqueness: true

  validates :min,       presence: true, numericality: true
  validates :max,       presence: true, numericality: true
  validates :start,     presence: true, numericality: true
  validates :step,      presence: true, numericality: true

  validate :max, :validate_max_gte_min

  # Custom validation - ensures that the maximum value, if present, is at
  # least equal to the minimum value, if present.
  #
  def validate_max_gte_min
    if min.present? and max.present? and min > max
      errors.add(:max, :less_than_min)
    end
  end

  # BEHAVIOUR ----------------------------------------------------------------

  default_value_for(:start) { |input| input.min }

end
