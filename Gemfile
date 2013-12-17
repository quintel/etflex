source 'http://rubygems.org'

RAILS_VERSION = '~> 3.2.11'

gem 'activesupport',  RAILS_VERSION, :require => 'active_support'
gem 'actionpack',     RAILS_VERSION, :require => 'action_pack'
gem 'activerecord',   RAILS_VERSION, :require => 'active_record'
gem 'actionmailer',   RAILS_VERSION, :require => 'action_mailer'
gem 'railties',       RAILS_VERSION, :require => 'rails'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'rack-proxy'

gem 'mysql2'
gem 'acts_as_list'
gem 'default_value_for'

gem 'haml', '~> 3.1'
gem 'jbuilder'
gem 'simple_form'
gem 'redcarpet'
gem 'gravtastic'

gem 'rest-client'

gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

gem 'jquery-rails', '~> 2.1.4'
gem 'jquery-ui-rails'

gem 'i18n-js'
gem 'rails-i18n'
gem 'http_accept_language'

gem 'pusher'

gem 'airbrake'
gem 'hashie'
gem 'json'
gem 'dotenv-rails', groups: [:development, :test, :production]

# Treetop for the grammars
gem 'treetop'

# Deploy with Capistrano
gem 'capistrano', '< 3.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # The Ruby Racer gives _much_ faster CoffeeScript compilation than simply
  # using Node since it all happens within the Ruby process; compilation with
  # Node fires up a new Node process for each source file, slowing things down
  # considerably in development..
  gem 'therubyracer', '>= 0.12'
  gem 'libv8',        '>= 3.16.14.3'

  gem 'sass',          '~> 3.2'
  gem 'sass-rails',    '~> 3.2'
  gem 'coffee-rails',  '>= 3.2.1'
  gem 'compass-rails', '>= 1.0.0'
  gem 'eco',           '~> 1.0'
  gem 'uglifier',      '>= 1.0.3'
end

group :production do
  # Use unicorn as the web server
  gem 'unicorn'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-shell'
  gem 'rb-fsevent'
  gem 'growl_notify'
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
  gem 'shoulda-matchers'

  # Integration / acceptance testing.
  gem 'capybara', '~> 2.1.0'
  gem 'poltergeist'
end
