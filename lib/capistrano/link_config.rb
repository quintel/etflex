# Returns the command to be run in order to create a symlink to a
# configuration file.
#
# @param [String] file The name of the file in the config/ directory.
#
def link_config_command(file)
  %( ln -sf "#{shared_path}/#{file}" "#{release_path}/#{file}" )
end

namespace :deploy do
  desc <<-DESC
    Creates symlinks to the configuration on the deployment server. Each \
    server has it's own copy of the configuration files (database.yml, etc) \
    which reside in the shared directory. This task creates a symlinks to \
    each of the config files into the "current_path" config directory.
  DESC
  task :link_config, roles: :app, except: { no_release: true } do
    run link_config_command('config/database.yml')
    run link_config_command('config/etflex.yml')
    run link_config_command('.env')
  end
end
