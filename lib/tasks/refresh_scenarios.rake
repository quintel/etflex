namespace :etflex do
  desc <<-DESC
    Recalculates scenarios from the past DAYS days by visiting ETengine asking
    it for the scenario score. DAYS defaults to 7.

      DAYS=14 rake etflex:refresh_scenarios

    Alternatively, you can supply a date using SINCE in YYYY-MM-DD format:

      SINCE=2012-12-20 rake etflex:refresh_scenarios
  DESC

  task refresh_scenarios: :environment do
    require 'etflex'
    require 'restclient'
    require 'json'

    # Public: Given a scenario, asks ETengine for the latest values for each
    # query used.
    #
    # scenario - The scenario whose new values you want
    #
    # Returns a hash of query results.
    def latest_values(scenario)
      base    = "#{ ETFlex.config.api_url }/api/v3"
      path    = "#{ base }/scenarios/#{ scenario.session_id }"
      result  = RestClient.put(path, gqueries: scenario.query_results.keys)

      queries = JSON.parse(result)['gqueries']

      queries.each_with_object({}) do |(key, data), hash|
        hash[key] = data['future']
      end
    end

    if ENV['SINCE']
      since = (Date.today - Date.parse(ENV['SINCE'])).to_i
    else
      since = (ENV['DAYS'] || 7).to_i
    end

    Scenario.where('updated_at >= ?', since.days.ago).each do |scenario|
      puts "Updating id=#{ scenario.id } session_id=#{ scenario.session_id }"

      values = latest_values(scenario)

      if values.length != scenario.query_results.length
        raise "ETengine did not return the exected number of results."
      end

      if values.any? { |key, value| value.blank? }
        raise "ETengine returned a blank values."
      end

      scenario.update_attributes!(query_results: values)
    end

    puts 'All done!'
  end
end
