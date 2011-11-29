source 'http://rubygems.org'

RAILS_VERSION = '~> 3.1.2'

gem 'activesupport',  RAILS_VERSION, :require => 'active_support'
gem 'actionpack',     RAILS_VERSION, :require => 'action_pack'
gem 'railties',       RAILS_VERSION, :require => 'rails'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mongoid', '~> 2.3'
gem 'bson_ext'
gem 'mongoid-list', git: 'git://github.com/davekrupinski/mongoid-list.git'

gem 'haml', '~> 3.1'
gem 'jsonify-rails'

gem 'jquery-rails'

gem 'i18n-js'
gem 'rails-i18n'

gem 'airbrake'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # The Ruby Racer gives _much_ faster CoffeeScript compilation than simply
  # using Node since it all happens within the Ruby process; compilation with
  # Node fires up a new Node process for each source file, slowing things down
  # considerably in development..
  gem 'therubyracer'
  gem 'sass-rails',   '>= 3.1.4'
  gem 'coffee-rails', '>= 3.1.1'
  gem 'compass',      '~> 0.12.alpha.0'
  gem 'eco',          '~> 1.0'
  gem 'uglifier'
end

group :production do
  # Use unicorn as the web server
  gem 'unicorn'

  # Used for monitoring processes; not actually loaded in the Rails app.
  gem 'bluepill', require: false
end

# Deploy with Capistrano
gem 'capistrano'

group :test, :development do
  # gem 'ruby-debug19', :require => 'ruby-debug'

  # An effective alternative to ruby-debug; call "binding.pry" instead
  # of "debugger"
  gem 'pry', '>= 0.9.7'

  # rspec-rails needs to be added to the development environment, otherwise
  # the spec:* tasks won't be available when using rake.
  gem 'rspec-rails',  '~> 2.6'

  # Same with Guard.
  gem 'guard'
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'growl_notify'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'

  # Swap back to official release when >=1.4.5 is released.
  gem 'mongoid-rspec', git: 'git://github.com/evansagge/mongoid-rspec.git'

  # Integration / acceptance testing.
  gem 'capybara', '>= 1.1.1'
end
