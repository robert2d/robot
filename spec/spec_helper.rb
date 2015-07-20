require 'rubygems'
require 'json'
require 'simplecov'

SimpleCov.start

require 'robot'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.expose_dsl_globally = true
  config.order = :random
end
