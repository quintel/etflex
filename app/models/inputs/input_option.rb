class InputOption
  attr_accessor :key, :effects

  def initialize(definition)
    @key      = definition["key"]
    @effects  = definition["effects"]
  end
end
