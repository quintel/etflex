require File.expand_path(File.dirname(__FILE__)) + '/production'

ETFlex::Application.configure do
  # Settings specified here will take precedence over those in
  # config/application.rb

  # Required by Devise.
  config.action_mailer.default_url_options = {
    host: 'beta.etflex.et-model.com' }
end
