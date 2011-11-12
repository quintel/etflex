load    'deploy'
require 'bundler/capistrano'
require 'capistrano-unicorn'

load    'lib/capistrano/link_config'

_cset(:stage) { 'production' }

# Determines the name of the application. ETflex in production mode will simply
# be "etflex", while other deployments (indicated by the "stage" configuration,
# will append the stage name.
#
# Examples:
#
#   +---------------+------------------+
#   | "stage" value | application name |
#   +---------------+------------------+
#   | production    | etflex           |
#   | staging       | etflex_staging   |
#   | rc            | etflex_rc        |
#   +---------------+------------------+
#
def application_name
  if stage == 'production' then 'etflex' else "etflex_#{ stage }" end
end

# APPLICATION CAPISTRANO CONFIGURATION ---------------------------------------

set :application, 'etflex'
set :user,        'ubuntu'
set :use_sudo,     false

# Git Repository.

set :scm,         :git
set :repository,  'git@github.com:dennisschoenmakers/etflex.git'
set :deploy_via,  :remote_cache

ssh_options[:forward_agent] = true

# DEPLOYMENT TARGETS ---------------------------------------------------------

task :production do
  set :stage,   'production'
  set :branch,  'unicorn'

  set :deploy_to, "/home/ubuntu/apps/#{application_name}"

  set :db_host, 'etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com'
  set :db_pass, 'acutZUVT56PoGI'
  set :db_name, 'etflex'
  set :db_user, 'etflex'

  # One server currently handles everything.
  server 'etflex.et-model.com', :web, :app, :db, primary: true
end

# COMMON CONFIGURATION -------------------------------------------------------

# If you change this, be sure to also change config/unicorn/:stage.rb
set :unicorn_pid, "#{deploy_to}/current/tmp/pids/unicorn.pid"

# Symlink database.yml, etc.
after 'deploy:update_code', 'deploy:link_config'

# ----------------------------------------------------------------------------

# vim: set filetype=ruby :
