require 'rubygems'
require 'simplecov'
# require 'coveralls'
# Coveralls.wear!

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  # Coveralls::SimpleCov::Formatter
]
SimpleCov.start 'rails'

require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  # Authlogic
  require 'authlogic/test_case'
  include Authlogic::TestCase

  # Stub mock web requests
  require 'webmock/rspec'
  WebMock.disable_net_connect!

  FIXTURE_PATH = File.expand_path("../fixtures", __FILE__)

  RSpec.configure do |config|
    config.mock_with :rspec
    require "factory_girl"
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
  end
end

Spork.each_run do
  load "#{Rails.root}/config/routes.rb"
  Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }
end


def fixture(file)
  File.new(FIXTURE_PATH + '/' + file)
end
