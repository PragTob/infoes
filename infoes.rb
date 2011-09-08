# infoes is a reader that aims to combine multiple services

# yeah we actually need Twitter
Shoes.setup do
  gem 'twitter'
end


require './rss'

Shoes.app :title => "infoes" do
  background gradient(lime, limegreen)
  stroke black
  title "This is infoes!", :align => "center"
  rss = load_rss "http://pragtob.wordpress.com/feed/"
  stack do
    rss.items.each do |each|
      para each.title
      para link("Go to Post", click: each.link)
    end
  end
end

