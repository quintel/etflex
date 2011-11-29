module Props
  # Icon is a prop which commonly sits at the bottom of a scene; it shows the
  # value of a query and fades the icon between alternative images based on
  # the query value.
  #
  class Icon < Base

    # FIELDS -----------------------------------------------------------------

    field :query_key, type: String

    # Icon transitions between different states depending on the query value.
    embeds_many :states, class_name: 'Props::State', as: :stateful

    # VALIDATION -------------------------------------------------------------

    validates :query_key, presence: true

  end # Icon
end # Props
