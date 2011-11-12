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

  # If you change this, be sure to also change config/unicorn/production.rb
  set :unicorn_pid, '/home/ubuntu/apps/etflex/current/tmp/pids/unicorn.pid'

  # One server currently handles everything.
  server 'etflex.et-model.com', :web, :app, :db, primary: true
end

# ----------------------------------------------------------------------------

# Needs to be last.
require 'capistrano-unicorn'

# vim: set filetype=ruby :
