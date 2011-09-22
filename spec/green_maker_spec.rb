require_relative "../lib/green_maker"
PATH = "spec/test_files/"

describe "GreenMaker" do

  after :each do
    Dir.chdir(PATH) do
      Dir.glob("*.*").each do |file|
        File.delete file
      end
    end
  end

  it "should remove Shoes.setup and replace it with require 'green_shoes'" do
    File.open(PATH + "in.rb", "w") do |f|
      f.write "Shoes.setup do
                 gem 'bla'
                 gem 'something'
               end"
    end

    GreenMaker.make_green(PATH + "in.rb", PATH + "out.rb")
    new_source = File.read PATH + "out.rb"
    new_source.should_not match /Shoes.setup/
    new_source.should_not match /gem/
    new_source.should_not match /end/
    new_source.should match /require 'green_shoes'/
  end

end

