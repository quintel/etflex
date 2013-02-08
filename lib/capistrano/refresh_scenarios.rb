namespace :etflex do
  desc <<-DESC
    Runs the etflex:refresh_scenarios rake task on the server. Additional
    information can be viewed in the documentation for that task:

      rake -D etflex:refresh_scenarios

    Like the Rake task, you may optionally provide a DAYS or SINCE argument.
  DESC

  task :refresh_scenarios, roles: :app, except: { no_release: true } do
    since = days = ''

    days  = "DAYS='#{ ENV['DAYS'] }' "   if ENV['DAYS']
    since = "SINCE='#{ ENV['SINCE'] }' " if ENV['SINCE']

    run("cd #{ current_path } && " +
      "#{ days }#{ since }bundle exec rake etflex:refresh_scenarios")
  end
end
