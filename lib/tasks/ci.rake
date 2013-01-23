namespace :ci do
  desc <<-DESC
    Runs tasks to prepare a CI build on Semaphore.
  DESC

  task :setup do
    # Config.
    if File.exists?('config/etflex.yml')
      raise 'config/etflex.yml already exists. Not continuing.'
    end

    original = YAML.load_file('config/etflex.sample.yml')
    config   = { 'development' => original['ci'], 'test' => original['ci'] }

    File.write('config/etflex.yml', YAML.dump(config))
  end
end
