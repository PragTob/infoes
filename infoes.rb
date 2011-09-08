# infoes is a reader that aims to combine multiple services

# yeah we actually need Twitter
Shoes.setup do
  gem 'twitter'
  gem 'oauth'
  gem 'launchy'
end

# open links in default browser (see shoes issue #138)
require 'launchy'

MENU_WIDTH = 120

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
      para link("Twitter Settings") { show_twitter_settings }
    end

    rss = load_rss "http://pragtob.wordpress.com/feed/"
    @content_box = stack width: -MENU_WIDTH do
      rss.items.each do |rss_item|
        para rss_item.title, " ", link("Go to Post") { Launchy.open rss_item.link }
      end
    end
  end
end

def show_twitter_settings
  Shoes.app :title => "Twitter Settings" do
    background gradient(deepskyblue, royalblue)
    button "Connect infoes with twitter" do
      authorization_url = get_request_token
      Launchy.open authorization_url
      pincode = ask "A page should have been opened in your web browser. Please authorize this app and then enter the
      pincode displayed to you here."
      complete_authentication pincode
      alert "Succesfully registered with Twitter!"
    end
    para link("Sign up at Twitter", click: "https://twitter.com/signup")
  end
end

