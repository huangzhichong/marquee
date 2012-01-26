ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl'
require File.dirname(__FILE__) + "/../test/factories"

RSpec.configure do |config|
  config.mock_with :rspec
end
