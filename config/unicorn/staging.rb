require File.expand_path(File.dirname(__FILE__)) + '/production'

# We require fewer workers in the staging environment.
worker_processes 2
