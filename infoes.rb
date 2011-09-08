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
      button "Twitter Settings" do
        show_twitter_settings
      end
    end

    rss = load_rss "http://pragtob.wordpress.com/feed/"
    @content_box = stack width: -MENU_WIDTH do
      rss.items.each do |rss_item|
        para rss_item.title, " ", link("Go to Post", click: rss_item.link)
      end
    end
  end
end

def show_twitter_settings
  Shoes.app :title => "Twitter Settings" do
    background gradient(deepskyblue, dodgerblue)
    button "Connect infoes with twitter" do
      alert "Implement me!!!!"
    end
    para link("Signe up at Twitter", click: "https://twitter.com/signup")
  end
end

