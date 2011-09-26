source 'http://rubygems.org'

RAILS_VERSION = '~> 3.1.0'

gem 'activesupport',  RAILS_VERSION, :require => 'active_support'
gem 'activerecord',   RAILS_VERSION, :require => 'active_record'
gem 'actionpack',     RAILS_VERSION, :require => 'action_pack'
gem 'railties',       RAILS_VERSION, :require => 'rails'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

gem 'haml',           '~> 3.1.3'
gem 'jquery-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   RAILS_VERSION
  gem 'coffee-rails', RAILS_VERSION
  gem 'compass',      '~> 0.12.alpha.0'
  gem 'eco',          '~> 1.0'
  gem 'uglifier'
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

group :test, :development do
  gem 'ruby-debug19', :require => 'ruby-debug'

  # rspec-rails needs to be added to the development environment, otherwise
  # the spec:* tasks won't be available when using rake.
  gem 'rspec-rails',  '~> 2.6'
end

group :test do
  gem 'database_cleaner'
  gem 'cucumber-rails'
end
