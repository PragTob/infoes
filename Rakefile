require_relative "lib/green_maker"

INFOES_FILE_NAME = 'infoes.rb'
GREENFOES_FILE_NAME = 'greenfoes.rb'

task :default => :green_shoes

desc "Creat a greenshoes version of infoes"

task :green_shoes do
  GreenMaker.make_green INFOES_FILE_NAME, GREENFOES_FILE_NAME
end

