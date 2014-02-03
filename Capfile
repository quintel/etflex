require 'bundler/capistrano'
require 'airbrake/capistrano'

load 'deploy'
load 'deploy/assets'

load 'lib/capistrano/link_config'
load 'lib/capistrano/refresh_scenarios'
load 'lib/capistrano/unicorn'
load 'lib/capistrano/database'

# Determines the name of the application. ETflex in production mode will
# simply be "etflex", while other deployments (indicated by the "rails_env"
# configuration, will append the environment name.
#
# Examples:
#
#   +-------------------+------------------+
#   | "rails_env" value | application name |
#   +-------------------+------------------+
#   | production        | etflex           |
#   | staging           | etflex_staging   |
#   | rc                | etflex_rc        |
#   +-------------------+------------------+
#
def application_name
  if rails_env == 'production' then 'etflex' else "etflex_#{ rails_env }" end
end

# Reads and returns the contents of a remote +path+, caching it in case of
# multiple calls.
def remote_file(path)
  @remote_files ||= {}
  @remote_files[path] ||= capture("cat #{ path }")
end

# Reads the remote .env file to set the Airbrake key locally in Capistrano.
def remote_airbrake_key
  key = remote_file("#{shared_path}/.env").match(/^AIRBRAKE_API_KEY=(.+)$/)
  key && key[1]
end

# Reads a remote config file to fetch the value of an attribute. If a matching
# environment variable is set (prefixed with "DB_"), it will be used instead.
def remote_db_config(key)
  ENV["DB_#{ key.to_s.upcase }"] ||
    YAML.load(
      remote_file("#{shared_path}/config/database.yml")
    )[rails_env.to_s][key.to_s]
end

# APPLICATION CAPISTRANO CONFIGURATION ---------------------------------------

set :application,  'etflex'
set :user,         'ubuntu'
set :use_sudo,      false

# Git Repository.

set :scm,          :git
set :repository,   'https://github.com/quintel/etflex.git'
set :deploy_via,   :remote_cache

set :bundle_flags, '--deployment --quiet --binstubs --shebang ruby-local-exec'

ssh_options[:forward_agent] = true

# DEPLOYMENT TARGETS ---------------------------------------------------------

task :production do
  set :rails_env, 'production'
  set :branch,    fetch(:branch, 'production')

  server 'etflex.et-model.com', :web, :app, :db, primary: true

  set :deploy_to, "/u/apps/#{application}"

  set :db_host, remote_db_config(:host)
  set :db_pass, remote_db_config(:password)
  set :db_name, remote_db_config(:database)
  set :db_user, remote_db_config(:username)

  set :airbrake_key, remote_airbrake_key
end

task :staging do
  set :rails_env, 'staging'
  set :branch,    fetch(:branch, 'staging')

  server 'beta.etflex.et-model.com', :web, :app, :db, primary: true

  set :deploy_to, "/u/apps/#{application}"

  set :db_host, remote_db_config(:host)
  set :db_pass, remote_db_config(:password)
  set :db_name, remote_db_config(:database)
  set :db_user, remote_db_config(:username)

  set :airbrake_key, remote_airbrake_key
end


# COMMON CONFIGURATION -------------------------------------------------------

# Configuration options which depend on values set in :production, :staging,
# etc, MUST be set in a block.

# Symlink database.yml, etc.
before 'deploy:assets:precompile', 'deploy:link_config'
after  'deploy:update_code',       'deploy:link_config'
after  'deploy:update',            'deploy:cleanup'

# ----------------------------------------------------------------------------

# vim: set filetype=ruby :
