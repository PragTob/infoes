require_relative "lib/green_maker"
require 'rspec/core/rake_task'

INFOES_FILE_NAME = 'infoes.rb'
GREENFOES_FILE_NAME = 'greenfoes.rb'


RSpec::Core::RakeTask.new
task :default => :spec
task :test => :spec

desc "Creat a greenshoes version of infoes"

task :green_shoes do
  GreenMaker.make_green INFOES_FILE_NAME, GREENFOES_FILE_NAME
end

