namespace :etflex do
  desc <<-DESC
    Runs the etflex:refresh_scenarios rake task on the server. Additional
    information can be viewed in the documentation for that task:

      rake -D etflex:refresh_scenarios

    Like the Rake task, you may optionally provide a DAYS or SINCE argument.
  DESC

  task :refresh_scenarios, roles: :app, except: { no_release: true } do
    vars = {
      'DAYS'      => ENV['DAYS'],
      'SINCE'     => ENV['SINCE'],
      'RAILS_ENV' => rails_env
    }

    vars = vars.reject { |_, value| value.nil? }.map do |key, value|
      "#{ key }='#{ value }'"
    end.join(' ')

    run("cd #{ current_path } && " +
      "#{ vars } bundle exec rake etflex:refresh_scenarios")
  end
end
