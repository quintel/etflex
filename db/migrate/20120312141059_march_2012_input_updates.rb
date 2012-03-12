class March2012InputUpdates < ActiveRecord::Migration
  def up
    data = YAML.load_file Rails.root.join('db/seeds/inputs.yml')
    data = data.each_with_object({}) do |input_data, hash|
      hash[ input_data['key'] ] = input_data
    end

    say_with_time 'Updating input start values' do
      Input.find_each(batch_size: 50) do |input|
        if data.key?( input.key )
          input.update_attributes! start: data[ input.key ]['start']
          data.delete( input.key )
        else
          # No such input exists anymore, remove it.
          input.destroy
        end
      end
    end

    # Any inputs left in data are inputs which do not yet exist in the
    # ETFlex database; lets add them!
    say_with_time 'Adding new inputs' do
      data.each do |input_key, input_data|
        Input.create! input_data
      end
    end

    # To save everyones sanity, unset any custom starting values for
    # SceneInput records.
    SceneInput.all.each { |sp| sp.update_attributes! start: nil }
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
