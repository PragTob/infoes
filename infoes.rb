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
      para link("RSS feed Settings") { show_rss_settings }
    end

    # main content
    rss = load_rss "http://pragtob.wordpress.com/feed/"
    tweets = TwitterConnection.get_tweets 10
    @content_box = stack width: -MENU_WIDTH do
      rss.items.each do |rss_item|
        para rss_item.title, " ", link("Go to Post") { Launchy.open rss_item.link }
      end
      tweets.each do |tweet|
        flow do
          stack width: 60, height: 60 do
            image tweet.user.profile_image_url
          end
          stack width: -60 do
            para tweet.user.name, ": ", tweet.text
          end
        end
      end
    end
  end
end

def show_twitter_settings
  Shoes.app :title => "Twitter Settings", :height => 300, :width => 300 do
    background gradient(deepskyblue, royalblue)
    stack do
      button "Connect infoes with twitter" do
        authorization_url = TwitterConnection.get_request_token
        Launchy.open authorization_url
        pincode = ask "A page should have been opened in your web browser. Please authorize this app and then enter the
        pincode displayed to you here."
        TwitterConnection.complete_authentication pincode
        alert "Succesfully registered with Twitter!"
        close
      end
      para link("Sign up at Twitter") { Launchy.open "https://twitter.com/signup" }
    end
  end
end

def show_rss_settings
  Shoes.app title: "RSS Feed Settings", width: 500, height => 400 do
    background gradient(gold, darkorange)
    stack do
      flow do
        para "RSS link: "
        @editline = edit_line
        button "Add" do
          alert "Implement me!"
        end
        button "Remove"
      end
    end
  end
end

