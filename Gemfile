ruby '2.5.9'

source 'https://rubygems.org'

gem 'rails', '~> 4.1'

# https://stackoverflow.com/questions/35893584/nomethoderror-undefined-method-last-comment-after-upgrading-to-rake-11
gem 'rake', '< 11.0'

gem 'rack-proxy'

gem 'mysql2'
gem 'acts_as_list'
gem 'default_value_for'

gem 'haml', '~> 4.0'
gem 'jbuilder'
gem 'simple_form'
gem 'redcarpet'
gem 'gravtastic'

gem 'rest-client'

gem 'devise'

gem 'jquery-rails', '~> 2.1.4'
gem 'jquery-ui-rails', '~> 6.0'

gem 'i18n-js'
gem 'rails-i18n'
gem 'http_accept_language'

gem 'pusher'
gem 'responders'

gem 'sentry-raven'
gem 'hashie'
gem 'json'

# Treetop for the grammars
gem 'treetop'

gem 'mini_racer'
gem 'sass-rails',    '~> 4.0'
gem 'coffee-rails',  '>= 3.2.1'
gem 'compass-rails', '>= 1.0.0'
gem 'eco',           '~> 1.0'
gem 'uglifier',      '>= 1.0.3'

gem 'animation'

group :production, :staging do
  gem 'puma'
  gem 'newrelic_rpm'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rb-fsevent'
end

group :test, :development do
  # gem 'ruby-debug19', :require => 'ruby-debug'

  # An effective alternative to ruby-debug; call "binding.pry" instead
  # of "debugger"
  gem 'pry', '>= 0.9.7'

  # rspec-rails needs to be added to the development environment, otherwise
  # the spec:* tasks won't be available when using rake.
  gem 'rspec-rails', '~> 3.4.2'
  gem 'factory_bot_rails'
  gem 'launchy'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-collection_matchers'
  gem 'rspec-its'
  gem 'shoulda-matchers'

  # Integration / acceptance testing. The webdrivers gem includes drivers for
  # Chrome, Firefox and Edge, but we currently use only the Chrome ones.
  gem 'capybara'
  gem 'capybara-selenium'
  gem 'webdrivers', '~> 3.0'
end
