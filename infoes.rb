# infoes is a reader that aims to combine multiple services

require './rss'

Shoes.app :title => "infoes" do
  background green
  stroke black
  title "This is infoes!", :align => "center"
  rss = load_rss "http://pragtob.wordpress.com/feed/"
  stack do
    rss.items.each do |each|
      para each.title
      para each.link
    end
  end
end

