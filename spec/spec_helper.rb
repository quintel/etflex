# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'shoulda/matchers'

# Make sure Capybara ignores hidden elements so that we can match against
# script tags.
Capybara.ignore_hidden_elements = false

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods

  config.include Devise::TestHelpers,      type: :controller
  config.include ETFlex::Spec::SignIn,     type: :request
  config.include ETFlex::Spec::WaitForXHR, type: :request
  config.include WaitSteps
  config.include Capybara::DSL

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

  config.treat_symbols_as_metadata_keys_with_true_values = true

  # Languages
  # ---------

  # Default all test runs to use English; you can change this in each
  # individual test, or in a before(:each) block.
  #
  config.before(:each) { I18n.locale = 'en' }

  # Database
  # --------

  # Integration tests should use truncation; real requests aren't wrapped
  # in a transaction, so neither should high-level tests. These filters need
  # to be above the filter which starts DatabaseCleaner.

  config.before(:each, type: :request) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each, type: :request) do
    DatabaseCleaner.strategy = :transaction
  end

  # The database_cleaner gem is used to restore the DB to a clean state before
  # each example runs. This is used in preference over rspec-rails'
  # transactions since we also need this behaviour in Cucumber features.

  config.before(:suite) { DatabaseCleaner.strategy = :transaction }
  config.before(:each)  { DatabaseCleaner.start                   }
  config.after(:each)   { DatabaseCleaner.clean                   }

  # Conference specs enable the conference mode.
  config.before(:each, conference: true) { ETFlex.config.conference = true  }
  config.after(:each, conference: true)  { ETFlex.config.conference = false }

  # Clear localStorage after each JS request.
  config.after(:each, js: true) do
    page.execute_script(
      'localStorage && localStorage.clear && localStorage.clear();')
  end

  # Capybara
  # --------
  require 'capybara/poltergeist'
  Capybara.javascript_driver = :poltergeist
  # Capybara.javascript_driver = :webkit

  Capybara.register_driver :rack_test_api do |app|
    Capybara::RackTest::Driver.new(app, headers: {
      'HTTP_ACCEPT'  => 'application/json',
      'CONTENT_TYPE' => 'application/json'
    })
  end

  # Steps with the "api" meta-data should ask for JSON.
  config.before(:each, api: true) { Capybara.current_driver = :rack_test_api }
  config.after(:each,  api: true) { Capybara.current_driver = :rack_test     }

end
