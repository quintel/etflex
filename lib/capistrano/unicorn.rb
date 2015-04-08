namespace :deploy do
  def set_unicorn_variables
    set :unicorn_binary, "#{current_path}/bin/unicorn"
    set :unicorn_config, "#{current_path}/config/unicorn/#{rails_env}.rb"
    set :unicorn_pid,    "#{current_path}/tmp/pids/unicorn.pid"
  end

  task :start, roles: :app, except: { no_release: true } do
    set_unicorn_variables
    run "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end

  task :stop, roles: :app, except: { no_release: true } do
    set_unicorn_variables
    run "kill `cat #{unicorn_pid}`"
  end

  task :graceful_stop, roles: :app, except: { no_release: true } do
    set_unicorn_variables
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end

  desc <<-DESC
    Reloads the Unicorn configuration and restarts Rails. Equivalent to
    sending a USR2 to the master process.
  DESC
  task :reload, roles: :app, except: { no_release: true } do
    set_unicorn_variables
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end

  task :restart, roles: :app, except: { no_release: true } do
    reload
  end
end