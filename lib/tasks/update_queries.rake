namespace :etflex do
  desc <<-DESC
    Updates the queries so that we have the minimum and maximum expected
    values for all of those used by ETFlex scenarios for each country.
  DESC

  task update_queries: :environment do
    puts 'The update_queries task is presently unused since it is not ' \
         'possible to balance the grouped queries, nor to get the minimum ' \
         'and maximum queries values without either: 1) Accepting that ' \
         'the min/max will be naive [retrieved by setting all the inputs ' \
         'to their minima and maxima], or; 2) sending several hundred ' \
         'trial-and-error requests.'

    exit 1

    PROPS_DIR = Rails.root.join('client/views/props')

    def simplified_filename(path)
      path.to_s.gsub(
        Regexp.new("#{ Regexp.escape(PROPS_DIR.to_s) }/"), ''
      ).chomp(path.extname)
    end

    def get_prop_index
      index_file = File.read(Rails.root.join('client/views/props.coffee'))

      # Remove everything preceeding the props hash.
      index_file.gsub!(/\A.*?  # =BEGIN PROPS/m,  '')

      # Remove everything following the props hash.
      index_file.gsub!(/^  # =END PROPS.*\Z/m, '')

      # Remove the ", 'ClassName'
      index_file.gsub!(/,.*$/, '')

      # Remove the "p" include function.
      index_file.gsub!(/\bp '/, "'")

      # And change the "h" include function to use the correct file path.
      index_file.gsub!(/\bh '/, "'headers/")

      # Finally turn it into a Ruby hash.
      index_file.gsub!(':', '=>')
      index_file = index_file.split("\n").select(&:present?).join(',')

      eval "{ #{ index_file } }"
    end

    # Sends an API request to the given path on ETEngine and returns the
    # HTTP response.
    def api(path, options = {}, method = :get)
      path = "#{ ETFlex.config.api_url }/api/v2/api_scenarios/#{ path }.json"
      JSON.parse(RestClient.__send__(method, path, options))
    end

    # Sends an API request for a scenario, returning the HTTP response.
    # Supply an array of queries whose results you want, and a hash of
    # inputs and their values you want sending.
    def scenario(id, queries = [], inputs = {})
      params = {}

      params['result'] = queries.to_a if queries.any?
      params['input']  = inputs       if inputs.any?

      api(id, params, :put)
    end

    # Given a scene, returns the mapped value from it's inputs.
    def map_inputs(scene, value)
      scene.inputs.each_with_object({}) do |input, hash|
        hash[ input.remote_id ] = input.__send__(value)
      end
    end

    require 'restclient'
    require 'json'

    prop_index = get_prop_index
    file_index = prop_index.invert

    query_index     = Hash.new { |hash, key| hash[key] = Set.new }
    view_files_glob = Rails.root.join('client/views/**/*.coffee')

    Pathname.glob(view_files_glob).each do |view_path|
      match = File.read(view_path).match(/@queries: (?<queries>[^\]]+)/)
      next unless match

      file_key = simplified_filename(view_path)

      queries = match[:queries].gsub(/\[\s*/, '').split(/\n|,/).map do |query|
        query = query.strip.gsub(/^['"](.+?)['"]$/, '\1')
        query_index[ file_index[file_key] ].add(query) if query.present?
      end
    end

    Scene.includes(scene_props: :prop).each do |scene|
      queries_used = scene.props.uniq.each_with_object(Set.new) do |prop, set|
        query_index[ prop.behaviour ].each { |query| set.add(query) }
      end

      # Get the minimum values
      # ----------------------
      # Presently just assumes that reducing all inputs to the minimum value
      # will result in the lowest query values). A bad assumption...
      scenario_id = api('new')['api_scenario']['id']

      input_values = map_inputs(scene, :min)
      scenario(scenario_id, queries_used, input_values).inspect
    end
  end
end
