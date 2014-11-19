namespace :survey do
  desc 'Dump survey scenarios to a CSV and download'
  task dump: ['deploy:set_rails_env'] do
    on roles(:app) do
      within current_path do
        info 'Creating survey CSV on the server'

        with rails_env: fetch(:rails_env) do
          execute(:rake, 'survey:dump')
        end

        stamp = Time.now.utc.strftime('%Y-%m-%d_%H-%M-%S%z')

        unless File.directory?('tmp')
          FileUtils.mkdir('tmp')
        end

        download!(
          current_path.join('tmp/survey.csv'),
          "tmp/survey.#{ stamp }.csv"
        )

        execute(:rm, current_path.join('tmp/survey.csv'))

        info "Downloaded survey CSV to: tmp/survey.#{ stamp }.csv"
      end
    end
  end
end
