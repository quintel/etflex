class January2013EtsourceUpdates < ActiveRecord::Migration
  def up
    data = YAML.load_file Rails.root.join('db/seeds/inputs.yml')
    data = data.each_with_object({}) do |input_data, hash|
      hash[ input_data['key'] ] = input_data
    end

    # Before doing anything, make sure that we don't be deleting any of the
    # inputs used in SceneInput records.

    missing_dependents = SceneInput.all.reject do |scene_input|
      data.key?(scene_input.key) ||
        data.key?("DEPRECATED_#{ scene_input.key }")
    end

    if missing_dependents.any?
      raise "Cannot proceed because the following inputs will be deleted " \
            "despite being used by scene inputs: " +
             missing_dependents.map(&:key).sort.join(', ')
    end

    # Okay, we're good to go...

    unchanged = 0

    say_with_time 'Updating input start values' do
      Input.find_each(batch_size: 50) do |input|
        if data.key?( input.key )
          attributes = data[input.key]
          originals  = input.attributes.slice(*attributes.keys)

          if originals == attributes
            unchanged += 1
          else
            input.update_attributes! data[ input.key ]
            input_updated(input.key, data[ input.key ], originals)
          end

          data.delete(input.key)
        elsif data.key?( "DEPRECATED_#{ input.key }" )
          new_key = "DEPRECATED_#{ input.key }"

          input.update_attributes! data[ new_key ]
          data.delete(new_key)
          input_status(input.key, 'DEPRECATED')
        else
          # No such input exists anymore, remove it.
          input.destroy
          input_status(input.key, 'DELETE')
        end
      end
    end

    say "#{ unchanged } inputs were unchanged"

    # Any inputs left in data are inputs which do not yet exist in the
    # ETFlex database; lets add them!
    if data.any?
      say_with_time 'Adding new inputs' do
        data.each do |input_key, input_data|
          input_status(input_key, 'CREATE')
          Input.create!(input_data)
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  #######
  private
  #######

  def input_status(key, status)
    puts "     * #{ status }: #{ key }"
  end

  def input_updated(key, new_attrs, old_attrs)
    input_status(key, 'UPDATED')

    old_diff = {}
    new_diff = {}

    new_attrs.each do |key, value|
      if old_attrs[key] != value
        old_diff[key] = old_attrs[key]
        new_diff[key] = value
      end
    end

    puts "         old: #{ old_diff.inspect }"
    puts "         new: #{ new_diff.inspect }"
  end
end
