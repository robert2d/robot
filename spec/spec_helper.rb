require 'rubygems'
require 'json'
require 'simplecov'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

SimpleCov.start

require 'robot'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.expose_dsl_globally = true
  config.order = :random
end
