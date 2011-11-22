class Input < ActiveRecord::Base

  # VALIDATION ---------------------------------------------------------------

  validates :key,       presence: true, uniqueness: true
  validates :remote_id, presence: true, uniqueness: true

  validates :min,       presence: true, numericality: true
  validates :max,       presence: true, numericality: true
  validates :start,     presence: true, numericality: true
  validates :step,      presence: true, numericality: true
end
