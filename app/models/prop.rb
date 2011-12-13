class Prop < ActiveRecord::Base

  # VALIDATION ---------------------------------------------------------------

  validates :client_key, presence: true, length: { in: 1..100 }

end
