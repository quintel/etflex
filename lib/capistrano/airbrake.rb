namespace :deploy do
  desc <<-DESC
    Sends a message to Hoptoad notifying it that we have deployed a new \
    version of the application. Currently uses a hard-coded API_KEY so this \
    task needs to be adjusted if staging and release candidate servers are \
    added in the future.
  DESC
  task :notify_airbrake, except: { no_release: true } do
    settings = {
      API_KEY:  '01e791c3bad77c0fff202e222fca192f',
      RAILS_ENV: rails_env,
      TO:        fetch(:airbrake_env, fetch(:rails_env, 'production')),
      REVISION:  current_revision,
      REPO:      repository,
      USER:      ENV['USER'] || ENV['USERNAME']
    }

    settings       = settings.map { |key, val| "#{key}=#{val}" }.join(' ')
    notify_command = "bundle exec rake #{settings} airbrake:deploy"

    puts ' ** Notifying Airbrake of deployment'
    run  "cd #{release_path} && #{notify_command}"
    puts ' ** Airbrake notification complete'
  end
end
