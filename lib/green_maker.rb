# make a green shoes version of an app
class GreenMaker
  def self.make_green(inputfile_path, outputfile_path)
    content = File.read(inputfile_path)
    # m lets . match new lines
    content.gsub!(/Shoes\.setup do.*?end/m, "require 'green_shoes'")
    File.open(outputfile_path, 'w') { |file| file.write content }
  end
end

