class SceneInput < ActiveRecord::Base

  # RELATIONSHIPS ------------------------------------------------------------

  belongs_to :scene
  belongs_to :input

  # VALIDATION ---------------------------------------------------------------

  validates :scene_id, presence: true
  validates :input_id, presence: true

  # BEHAVIOUR ----------------------------------------------------------------

  acts_as_list scope: [ :scene_id, :placement ]

  # INSTANCE METHODS ---------------------------------------------------------

  # Returns if this input should be shown on the left-hand side of the
  # scene page.
  #
  def left?
    placement.blank?
  end

  # Returns if this input should be shown on the right-hand side of the
  # scene page.
  #
  def right?
    not left?
  end

end
