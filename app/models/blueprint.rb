class Blueprint < ActiveRecord::Base

  # VALIDATION ---------------------------------------------------------------

  validates :name, presence: true

end
