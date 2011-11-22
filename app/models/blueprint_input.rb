class BlueprintInput < ActiveRecord::Base

  # RELATIONSHIPS ------------------------------------------------------------

  belongs_to :blueprint
  belongs_to :input

  # VALIDATION ---------------------------------------------------------------

  validates :blueprint_id, presence: true
  validates :input_id,     presence: true

  validates :position,     presence: true,
                           numericality: { only_integer: true }

  # INSTANCE METHODS ---------------------------------------------------------

  # Returns if this input should be shown on the left-hand side of the
  # blueprint page.
  #
  def left?
    placement.blank?
  end

  # Returns if this input should be shown on the right-hand side of the
  # blueprint page.
  #
  def right?
    not left?
  end

end
