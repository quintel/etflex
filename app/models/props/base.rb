module Props
  # A base class from which the other Props should inherit. Don't save a
  # "Base" on it's own since that doesn't make any sense; create a Props::Icon,
  # Props::Gauge, etc.
  #
  class Base
    include Mongoid::Document
    store_in :props

    # FIELDS -----------------------------------------------------------------

    field :name, type: String

    # VALIDATION -------------------------------------------------------------

    validates :name, presence: true, length: { maximum: 100 }

  end # Base
end # Props
