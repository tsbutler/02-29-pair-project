ENV['RACK_ENV'] = 'test'
require 'simplecov'
SimpleCov.start do
  add_filter "/main.rb"
  add_filter "/config"
  add_filter "/tests/database_cleaner.rb"
  add_filter "/db"
end

require 'minitest/autorun'
require 'rack/test'

require_relative "./database_cleaner"

require 'tilt/erb'

class Minitest::Test
  include Rack::Test::Methods
end

require File.expand_path '../../main.rb', __FILE__