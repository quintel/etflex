source 'https://rubygems.org'

RAILS_VERSION = '~> 4.1.0'

gem 'rails', '~> 4.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'rack-proxy'

gem 'mysql2', '~> 0.3.18'
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
gem 'jquery-ui-rails'

gem 'i18n-js'
gem 'rails-i18n'
gem 'http_accept_language'

gem 'pusher'

gem 'airbrake'
gem 'hashie'
gem 'json'
gem 'dotenv-rails', groups: [:development, :test, :production, :staging]

# Treetop for the grammars
gem 'treetop'

# The Ruby Racer gives _much_ faster CoffeeScript compilation than simply
# using Node since it all happens within the Ruby process; compilation with
# Node fires up a new Node process for each source file, slowing things down
# considerably in development.
gem 'therubyracer',  '>= 0.12'
gem 'libv8',         '>= 3.16.14.3'

gem 'sass-rails',    '~> 4.0'
gem 'coffee-rails',  '>= 3.2.1'
gem 'compass-rails', '>= 1.0.0'
gem 'eco',           '~> 1.0'
gem 'uglifier',      '>= 1.0.3'

gem 'animation'

group :production, :staging do
  gem 'unicorn'
  gem 'newrelic_rpm'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-shell'
  gem 'rb-fsevent'

  # Deploy with Capistrano.
  gem 'capistrano',          '~> 3.0', require: false
  gem 'capistrano-rbenv',    '~> 2.0', require: false
  gem 'capistrano-rails',    '~> 1.1', require: false
  gem 'capistrano-bundler',  '~> 1.1', require: false
  gem 'capistrano3-unicorn', '~> 0.2', require: false
end

group :test, :development do
  # gem 'ruby-debug19', :require => 'ruby-debug'

  # An effective alternative to ruby-debug; call "binding.pry" instead
  # of "debugger"
  gem 'pry', '>= 0.9.7'

  # rspec-rails needs to be added to the development environment, otherwise
  # the spec:* tasks won't be available when using rake.
  gem 'rspec-rails',  '~> 2.8'
  gem 'factory_girl_rails'
  gem 'launchy'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false

  # Integration / acceptance testing.
  gem 'capybara', '~> 2.1.0'
  gem 'poltergeist'
end
