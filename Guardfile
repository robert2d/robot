# To exclude automatic running of tests, use the group filter e.g.
# `be guard -g no-tests`
# The above will only run global definitions and the group 'no-tests',
# which doesn't exist. This is to support starting a guard process in one
# window and then manually running `bundle exec rspec spec/<spec>` in
# another.
group :tests do
  guard :rspec, cmd: 'rspec --color' do
    watch(%r{^spec/.+_spec\.rb$})
    watch('spec/spec_helper.rb')                        { 'spec/' }
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  end
end
