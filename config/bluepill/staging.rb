# An example of "inheriting" from the production Bluepill configuration. Start
# Bluepill with:
#
#   bluepill load config/bluepill/staging.rb --no-privileged
#

ENV['RAILS_ENV']  ||= 'staging'
ENV['RAILS_ROOT'] ||= '/home/ubuntu/apps/etflex_staging/current'

# require_relative is only available in Ruby 1.9.2 and newer.
require_relative 'production'
