class OneToOneInput < Input
  attr_accessor :min, :max, :step, :options, :formula

  def initialize(key, definition)
    super key, definition

    @min      = definition["min"]
    @max      = definition["max"]
    @step     = definition["step"]
    @value    = @start
    @unit     = definition["unit"]

    @formula  = definition["formula"]

    # If the input is to be displayed with radio buttons,
    # options have to be specified for it.
    if @display == "radio"
      @options = []

      definition["options"].each do |option|
        @options << InputOption.new(option)
      end
    end
  end

  def values
    # Simply return the value unless there's a formula
    # that requires calculating
    return { @key => @value } unless @formula

    # Generate the formula's variable list and eval it
    variables = { @key => @value }
    result    = calculator.eval variables

    { @key => result }
  end
end
