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
    def api(path)
      RestClient.get "#{ ETFlex.config.api_url }/#{ path }"
    end

    # Sends an API request for a scenario, returning the HTTP response.
    def scenario(id, path)
      api("api_scenarios/#{ id }/#{ path }")
    end

    # Extracts a value from user_values.json; values are normally just an
    # integer but may sometimes be an array (?!).
    def extract_uv(from, attr)
      value = from.fetch(attr)
      if value.is_a?(Array) then value.first.to_f else value.to_f end
    end

    require 'etflex'
    require 'restclient'
    require 'json'

    # We start out by fetching the "raw" input data from the ETEngine API.
    # This is just a database dump of each input without the GQL min, max,
    # and start values, but we need this for the key and unit attributes.

    puts 'Fetching raw inputs...'

    raw_inputs = api('inputs.xml')
    raw_inputs = ActiveSupport::XmlMini.parse(raw_inputs)['inputs']['input']

    puts 'Parsing raw inputs...'

    inputs = raw_inputs.each_with_object({}) do |input, hash|
      hash[ input['id']['__content__'] ] =
        { 'key'       => input['key']['__content__'],
          'remote_id' => input['id']['__content__'].to_i,
          'unit'      => input['unit']['__content__'],
          'group'     => input['share-group']['__content__'] }
    end

    # Create a new API scenario, and fetch user_values so that we have the
    # GQL min, max, and start values.

    puts 'Fetching GQL values...'

    session    = JSON.parse(api('api_scenarios/new.json'))
    session_id = session['api_scenario']['id']

    values = RestClient.get("#{ ETFlex.config.api_url }/api_scenarios/" \
                            "#{ session_id }/user_values.json")

    values = JSON.parse(values)

    puts 'Parsing GQL values...'

    values.each do |(id, data)|
      begin
        input = inputs.fetch(id)

        input['min']   = extract_uv data, 'min_value'
        input['max']   = extract_uv data, 'max_value'
        input['start'] = extract_uv data, 'start_value'

        # '#' units should not be stored.
        input.delete('unit') if input['unit'] == '#'

        # Don't add a group: row when none is needed.
        input.delete('group') if input['group'].blank?

        # Try to come up with a sensible step value based on the difference
        # between the minimum and maximum.

        delta = (input['max'] - input['min']).abs

        if delta == 0
          input['step'] = 0
        else
          input['step'] = (10 ** Math.log(delta, 10).round.to_f) / 100
        end

      rescue Exception => e
        puts "Error with input: #{ id }, #{ data.inspect }"
        raise e

      end
    end # values.each

    File.open(Rails.root.join('db/seeds/inputs.yml'), 'w') do |f|
      f.puts YAML.dump(inputs.values)
    end

    puts "All done! (#{ inputs.length } inputs)"

  end # task :update_inputs
end # namespace :etflex
