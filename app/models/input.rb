class Input
  @@input_cache = {}

  attr_accessor :type, :key, :engine_key, :display, :value, :unit, :start,
                :parent

  def self.for_scene(key)
    definition  = load_definition 'scenes', key
    result      = {}

    definition["inputs"].each do |location, groups|
      result[location] ||= {}

      groups.each do |group, inputs|
        result[location][group] = []

        inputs.each do |input|
          if input.include? '->'
            parent, child = input.split ' -> '

            parent_input  = from_definition(parent)
            child_input   = parent_input.input_with_key(child)
            result[location][group] << child_input
          else
            result[location][group] << from_definition(input)
          end
        end
      end
    end

    result
  end

  def self.from_definition(key)
    return @@input_cache[key] if @@input_cache[key]

    definition = load_definition 'inputs', key

    case definition["type"]
    when "one_to_one"
      OneToOneInput.new key, definition
    when "one_to_many"
      OneToManyInput.new key, definition
    when "many_to_one"
      ManyToOneInput.new key, definition
    else
      raise "Invalid input type: #{definition["type"]}"
    end
  end

  def initialize(key, definition)
    @type       = definition["type"]
    @key        = key
    @engine_key = definition["engine_key"]
    @display    = definition["display"]
    @unit       = definition["unit"]
    @start      = definition["start"]
  end

  def calculator
    @calculator ||= begin
      path = Rails.root.join('app', 'grammars', 'arithmetic')
      @@parser  ||= Treetop.load path
      @@parser.parse @formula
    end
  end

  private
    def self.load_definition type, key
      path = Dir[Rails.root.join('config', type, '**', "#{key}.yml")][0]
      YAML.load_file(path)
    end
end
