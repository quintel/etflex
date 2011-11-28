class Prop
  include Mongoid::Document

  # FIELDS -------------------------------------------------------------------

  field :name, type: String

  # VALIDATION ---------------------------------------------------------------

  validates :name, presence: true, length: { maximum: 100 }

end
