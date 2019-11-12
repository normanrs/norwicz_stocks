require 'rake'
require "rake/testtask"


task default: "test"
tests_num = Dir["test/*_test.rb"].count
Rake::TestTask.new do |task|
  task.pattern = "test/*_test.rb"
end
puts "** Running #{tests_num} tests **"
