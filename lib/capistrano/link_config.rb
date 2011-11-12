# Returns the command to be run in order to create a symlink to a
# configuration file.
#
# @param [String] file The name of the file in the config/ directory.
#
def link_config_command(file)
  %( ln -s "#{shared_path}/config/#{file}" "#{release_path}/config/#{file}" )
end

namespace :deploy do
  task :link_config, roles: :app, except: { no_release: true } do
    run link_config_command('database.yml')
  end
end
