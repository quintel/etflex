namespace :etflex do
  desc <<-DESC
    Updates the inputs seed file with values from ETEngine. Creates a new
    ETEngine scenario and extracts the min, max, and start values from the
    user_values.json, updating the seed file.
  DESC

  # In the future, perhaps we should update the inputs in the DB in addition
  # to the seeds file.
  task :update_inputs do
    # Sends an API request to the given path on ETEngine and returns the
    # HTTP response.
    def api(path, method = :get, data = nil)
      JSON.parse(RestClient.public_send(
        method, "#{ ETFlex.config.api_url }/api/v3/#{ path }", data))
    end

    require 'etflex'
    require 'restclient'
    require 'json'

    scenario = api('scenarios', :post, scenario: {
      area_code: 'nl', end_year: 2030
    })

    scenario_id = scenario['id']

    # We start out by fetching the "raw" input data from the ETEngine API.
    # This is just a database dump of each input without the GQL min, max,
    # and start values, but we need this for the key and unit attributes.

    puts 'Fetching raw inputs...'

    raw_inputs = api('inputs.json', :get, params: { include_extras: true })

    puts 'Parsing raw inputs...'

    inputs = raw_inputs.each_with_object([]) do |(id, data), collection|
      begin
        input = { 'key' => id, 'remote_id' => id, 'start' => data['default'] }
        input.merge!(data.slice('min', 'max', 'step', 'unit'))

        if input['unit'].blank? && input['unit'] == '#'
          input.delete('unit') # Remote superflous units.
        end

        if data['share_group'].present?
          input['group'] = data['share_group']
        end

        collection.push(input)
      rescue RuntimeError => e
        puts "Error with input: #{ id }, #{ input.inspect }"
        raise e
      end
    end

    inputs.sort_by! { |input| input['key'].downcase }

    File.open(Rails.root.join('db/seeds/inputs.yml'), 'w') do |f|
      f.puts YAML.dump(inputs)
    end

    puts "All done! (#{ inputs.length } inputs)"

  end # task :update_inputs
end # namespace :etflex
