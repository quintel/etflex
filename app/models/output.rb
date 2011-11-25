class Output < ActiveRecord::Base

  serialize :type_data, Hash

  # VALIDATION ---------------------------------------------------------------

  validates :key,       presence: true
  validates :type_name, presence: true

end
