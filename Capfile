require 'bundler/capistrano'

load 'deploy'
load 'deploy/assets'

load 'lib/capistrano/airbrake'
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
  "rfi2d_flex_staging"
end

# APPLICATION CAPISTRANO CONFIGURATION ---------------------------------------

set :application,  'rfi2d_flex'
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

  set :deploy_to, "/u/apps/#{application}"

  set :db_host,   'etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com'
  set :db_pass,   'acutZUVT56PoGI'
  set :db_name,   'etflex'
  set :db_user,   'etflex'

  server 'etflex.et-model.com', :web, :app, :db, primary: true
end

task :staging do
  set :rails_env, 'staging'
  set :branch,    fetch(:branch, 'staging')

  set :deploy_to, "/u/apps/#{application}"

  set :db_host,   'etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com'
  set :db_pass,   'V20KpwldSTFSDr'
  set :db_name,   'etflex_staging'
  set :db_user,   'etflex_staging'

  server 'beta.etflex.et-model.com', :web, :app, :db, primary: true
end

task :rfi2d_flex_staging do
  set :rails_env, 'staging'
  set :branch,    fetch(:branch, 'rfi2d_flex_staging')

  set :deploy_to, "/u/apps/rfi2d_flex"

  set :db_host,   'etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com'
  set :db_pass,   'V20KpwldSTFSDr'
  set :db_name,   'rfi2d_flex_staging'
  set :db_user,   'rflex_staging'

  server 'beta.rfi2d-flex.et-model.com', :web, :app, :db, primary: true
end


# COMMON CONFIGURATION -------------------------------------------------------

# Configuration options which depend on values set in :production, :staging,
# etc, MUST be set in a block.

# Symlink database.yml, etc.
before 'deploy:assets:precompile', 'deploy:link_config'
after  'deploy:update_code',       'deploy:link_config'
after  'deploy:update',            'deploy:cleanup'
after  'deploy',                   'airbrake:notify'

# ----------------------------------------------------------------------------

# vim: set filetype=ruby :
