# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  before(:suite) { Debugger.start }

  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Tries to find examples / groups with the focus tag, and runs them. If no
  # examples are focues, run everything. Prevents the need to specify
  #
  #   $ rspec [...] --tag focus
  #
  # when you only want to run certain examples.
  #
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # Database
  # --------

  # The database_cleaner gem is used to restore the DB to a clean state before
  # each example runs. This is used in preference over rspec-rails'
  # transactions since we also need this behaviour in Cucumber features.

  config.before(:suite) { DatabaseCleaner.strategy = :transaction }
  config.before(:each)  { DatabaseCleaner.start                   }
  config.after(:each)   { DatabaseCleaner.clean                   }

end
