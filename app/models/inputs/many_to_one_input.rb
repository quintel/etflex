class ManyToOneInput < Input
  attr_accessor :inputs, :target, :formula

  def initialize(key, definition)
    super key, definition

    @formula  = definition["formula"]

    @inputs = []
    definition["inputs"].each do |input_definition|
      # TODO: Find a way to make this better
      input_definition["type"] = "one_to_one"

      child_key     = input_definition["key"]
      child_input   = OneToOneInput.new child_key, input_definition

      child_input.parent  = parent_definition(definition)
      @inputs << child_input
    end

    @formula  = definition["formula"]
  end

  def input_with_key(key)
    result = nil

    @inputs.each do |input|
      result = input if input.key == key
    end

    result
  end

  def calculate(values)
    calculator.eval(values)
  end

  # This method exists so that we can create a definition for this
  # input so that its child inputs can refer to it without creating
  # a circular reference.
  def parent_definition(definition)
    # Strip the inputs part as we don't want the circular reference
    result = definition.select { |k,v| k != "inputs" }

    # Add a list of inputs this one depends on
    result["dependant"] = definition["inputs"].map { |input| input["key"] }
    result.merge(key: @key)
  end
end
