require 'rake/testtask'

require 'sinatra/activerecord/rake'

namespace :db do
  task :load_config do
    require "./main"
  end
end

Rake::TestTask.new(:test) do |t|
  t.libs = %w(lib tests)
  t.pattern = 'tests/**/*_test.rb'
end

task :default => :test