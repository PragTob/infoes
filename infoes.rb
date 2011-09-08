# infoes is a reader that aims to combine multiple services

# yeah we actually need Twitter
Shoes.setup do
  gem 'twitter'
  gem 'oauth'
end

MENU_WIDTH = 100

# requires are strange but require_relative throws "Can't infer basepath errors"
require './rss'
require './twitter'

Shoes.app :title => "infoes" do
  background gradient(lime, limegreen)
  stroke black
  title "This is infoes!", :align => "center"
  flow do
    # menu items
    stack width: MENU_WIDTH do
      para "Twitter account setup"
    end

    rss = load_rss "http://pragtob.wordpress.com/feed/"
    stack width: -MENU_WIDTH do
      rss.items.each do |rss_item|
        para rss_item.title, " ", link("Go to Post", click: rss_item.link)
      end
    end
  end
end

