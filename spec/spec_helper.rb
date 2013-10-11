require 'rspec'
require 'plotrb'

RSpec.configure do |config|
  config.filter_run_excluding broken: true
end
