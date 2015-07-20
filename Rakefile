require 'bundler'
require 'rubocop/rake_task'
require 'rspec/core'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new do |t|
  t.formatters = %w(progress json)
  t.options = %w(--out coverage/rubocop.json)
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task default: [:spec, :rubocop]
