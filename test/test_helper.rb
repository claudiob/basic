ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start do
  enable_coverage :branch
  minimum_coverage 100
  cover '{app,lib}/**/*.rb'
  skip ['config/']
end

require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

require 'omen/stubs'
require 'stubs/google'
require 'stubs/twilio'

module ActiveSupport
  class TestCase
    parallelize workers: :number_of_processors

    # A worker's database is loaded from the schema alone, so grant the read-only roles on it.
    parallelize_setup do
      next if ApplicationRecord.with_connection { |connection| Omen::Bound.roles(connection).any? }

      told, $stdout = $stdout, StringIO.new
      Reader.grant
      Omen::Inquirer.grant
    ensure
      $stdout = told if told
    end

    # Rate limits count in the cache.
    setup { Rails.cache.clear }

    include GoogleStubs, Omen::Stubs, TwilioStubs

    fixtures :all

    setup { Current.reset }
  end
end
