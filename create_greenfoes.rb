INFOES_FILE_NAME = 'infoes.rb'
GREENFOES_FILE_NAME = 'greenfoes.rb'

infoes_file = File.new INFOES_FILE_NAME
greenfoes_file = File.new GREENFOES_FILE_NAME, 'w'

line = infoes_file.readline
until line =~ /Shoes.setup do/ do
  greenfoes_file << line
  line = infoes_file.readline
end

# we don't want the Shoes.setup line
line = infoes_file.readline
# foremost we need greenshoes
greenfoes_file << "require 'green_shoes'\n"
# substitute the shoes gem with the requires
until line =~ /end/ do
  greenfoes_file << line.gsub('gem', 'require').lstrip
  line = infoes_file.readline
end

# append the rest of the file
infoes_file.each { |line| greenfoes_file << line }

infoes_file.close
greenfoes_file.close

