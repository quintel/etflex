class OneToManyInput < Input
  attr_accessor :options

  def initialize(key, definition)
    super key, definition

    @options = []

    definition["options"].each do |option|
      @options << InputOption.new(option)
    end
  end

  def values

  end
end
