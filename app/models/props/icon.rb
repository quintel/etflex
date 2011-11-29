class Props::Icon < ActiveRecord::Base

  # RELATIONS ----------------------------------------------------------------

  has_many :states, class_name: 'Props::State', as: :prop

  # VALIDATION ---------------------------------------------------------------

  validates :query_id, presence: true

end
