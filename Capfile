load    'deploy'
require 'bundler/capistrano'

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
  set :branch,    'unicorn'
  set :deploy_to, '/home/ubuntu/apps/etflex'

  set :db_host,   'etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com'
  set :db_pass,   'acutZUVT56PoGI'
  set :db_name,   'etflex'
  set :db_user,   'etflex'

  # One server currently handles everything.
  server 'etflex.et-model.com', :web, :app, :db, primary: true
end

# ----------------------------------------------------------------------------

# vim: set filetype=ruby :
