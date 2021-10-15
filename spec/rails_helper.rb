# This file was copied form the old 'spec_helper'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'shoulda/matchers'
require 'spec_helper'

# Make sure Capybara ignores hidden elements so that we can match against
# script tags.
Capybara.ignore_hidden_elements = false

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ETFlex::Spec::SignIn,            type: :request
  config.include ETFlex::Spec::WaitForXHR,        type: :request
  config.include WaitSteps
  config.include Capybara::DSL

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

  config.use_transactional_fixtures = false

  config.before(:each, type: :request) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, sign_in: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each, type: :request) do
    DatabaseCleaner.strategy = :transaction
  end

  config.after(:each, sign_in: true) do
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
    page.execute_script('localStorage && localStorage.clear && localStorage.clear();')
  rescue Selenium::WebDriver::Error::WebDriverError
    # LocalStorage is unavailable when tests were skipped or pending.
  end

  # Capybara
  # --------
  require 'selenium/webdriver'

  Capybara.register_driver :rack_test_api do |app|
    Capybara::RackTest::Driver.new(app, headers: {
      'HTTP_ACCEPT'  => 'application/json',
      'CONTENT_TYPE' => 'application/json'
    })
  end

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.register_driver :headless_chrome do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w[headless disable-gpu] }
    )

    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: capabilities
    )
  end

  Capybara.javascript_driver = :headless_chrome

  # Steps with the "api" meta-data should ask for JSON.
  config.before(:each, api: true) { Capybara.current_driver = :rack_test_api }
  config.after(:each,  api: true) { Capybara.current_driver = :rack_test     }

  # Have Webdrivers check for updates
  Webdrivers.cache_time = 1.day.to_i
end
