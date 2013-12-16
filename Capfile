require 'bundler/capistrano'

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
  @remote_files[path] ||= YAML.load(capture("cat #{ path }"))
end

# Reads a remote config file to fetch the value of an attribute. If a matching
# environment variable is set (prefixed with "DB_"), it will be used instead.
def remote_config(file, key)
  ENV[key.to_s.upcase] ||
    remote_file("#{shared_path}/config/#{file}.yml")[rails_env.to_s][key.to_s]
end

# APPLICATION CAPISTRANO CONFIGURATION ---------------------------------------

set :application,  'etflex'
set :user,         'ubuntu'
set :use_sudo,      false

# Git Repository.

set :scm,          :git
set :repository,   'git@github.com:quintel/etflex.git'
set :deploy_via,   :remote_cache

set :bundle_flags, '--deployment --quiet --binstubs --shebang ruby-local-exec'

ssh_options[:forward_agent] = true

# DEPLOYMENT TARGETS ---------------------------------------------------------

task :production do
  set :rails_env, 'production'
  set :branch,    fetch(:branch, 'production')

  server 'etflex.et-model.com', :web, :app, :db, primary: true

  set :deploy_to, "/u/apps/#{application}"

  set :db_host,   remote_config(:database, :host)
  set :db_pass,   remote_config(:database, :password)
  set :db_name,   remote_config(:database, :database)
  set :db_user,   remote_config(:database, :username)
end

task :staging do
  set :rails_env, 'staging'
  set :branch,    fetch(:branch, 'staging')

  server 'beta.etflex.et-model.com', :web, :app, :db, primary: true

  set :deploy_to, "/u/apps/#{application}"

  set :db_host,   remote_config(:database, :host)
  set :db_pass,   remote_config(:database, :password)
  set :db_name,   remote_config(:database, :database)
  set :db_user,   remote_config(:database, :username)
end

task :show do
  %w( db_host db_pass db_name db_user ).each do |meth|
    puts "#{ meth }=#{ __send__(meth) }"
  end
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
