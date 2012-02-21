prod = File.read(File.expand_path(File.dirname(__FILE__)) + '/production.rb')
instance_eval(prod, __FILE__, __LINE__ + 1)

# We require fewer workers in the staging environment.
worker_processes 2
