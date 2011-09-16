# infoes is a reader that aims to combine multiple services
# TODO new class/file for every window, figure out how to this and then do it!
# generally more modularization

# yeah we actually need Twitter and a few other gems
Shoes.setup do
  gem 'twitter'
  gem 'oauth'
  gem 'launchy'
end

# open links in default browser (see shoes issue #138)
require 'launchy'

# requires are strange but require_relative throws "Can't infer basepath errors"
require './lib/rss'
require './lib/twitter'
require './lib/tweet'

MENU_WIDTH = 120

# will become a preference
TWEETS_TO_LOAD = 10
TWITTER_SIGNUP = "https://twitter.com/signup"

def done_button
  button("Done") { close }
end

def restart_notice
  para "Please note that you have to restart infoes in order for your changes ",
    "to take effect. This is a very early alpha version. I am sorry."
end

def basic_background
  background gradient(lime, limegreen)
end

# display the slot where a user may add a new url to his rss feeds
def new_rss_feed_slot
  flow do
    @new_url_edit = edit_line width: 300
    button("Add") do
      new_url = @new_url_edit.text
      RSSFeeds.add new_url

      # add the newly entered URL to the list of urls
      @main_stack.before(@new_url_slot) do
        rss_feed_source new_url
      end
      # clear the edit_line so the user can enter a new feed url
      @new_url_edit.text = ""
    end
  end
end

# creates a new RSS feed source entry for a given url
def rss_feed_source(url)
  this_entry = flow do
    para url, " "
    button("Remove") do
      RSSFeeds.remove url
      this_entry.clear
    end
  end
end

# Show the settings window for RSS
def show_rss_settings
  Shoes.app title: "RSS Feed Settings", width: 500, height: 300 do
    background gradient(gold, darkorange)

    @main_stack = stack do
      restart_notice
      RSSFeeds.urls.each do |url|
        rss_feed_source url
      end

      @new_url_slot = new_rss_feed_slot
      done_button
    end
  end
end

# the button that starts the connect to Twitter process
def connect_to_twitter_button
  button "Connect infoes with twitter" do
    authorization_url = TwitterConnection.get_request_token
    Launchy.open authorization_url
    pincode = ask <<-eos
                  A page should have been opened in your web browser.
                  Please authorize this app and then enter the
                  pincode displayed to you here.
                eos

    TwitterConnection.complete_authentication pincode
    alert "Succesfully registered with Twitter!"
    close
  end
end

# show the seperate Twitter settings window
def show_twitter_settings
  Shoes.app :title => "Twitter Settings", :height => 300, :width => 300 do
    background gradient(deepskyblue, royalblue)

    stack do
      unless TwitterConnection.already_authenticated?
        restart_notice
        connect_to_twitter_button
        para link("Sign up at Twitter") { Launchy.open TWITTER_SIGNUP }
      else
        para "Your Twitter account is already connected to infoes!"
      end
      done_button
    end
  end
end

def about
  Shoes.app width: 500, height: 250 do
    basic_background
    stack do
      para "Infoes was created by me as I got sick of ",
        "having to check Twitter, my RSS Feeds and Facebook."
      para "And of course because Ruby makes me happy."
      para "If you don't know who to follow on Twitter, try ",
        link("me") { Launchy.open "https://twitter.com/#!/PragTob" }, "."
      para "If you don't know which blog to follow, try ",
        link("my blog's RSS Feed") {
          # again {} necessary
          Launchy.open "http://pragtob.wordpress.com/feed/"
        } , "."
        done_button
      end
  end
end


# the main menu displayed on the left hand side
def menu
  stack width: MENU_WIDTH do
    para link("Twitter Settings") { show_twitter_settings }
    para link("RSS feed Settings") { show_rss_settings }
    para link("About") { about }
  end
end

def rss_entries
  rss = RSSFeeds.load
  rss.each do |feed|
    feed.items.each do |rss_item|
      para rss_item.title, " ",
          link("Go to Post") { Launchy.open rss_item.link }
    end
  end
end

def tweets
  tweets = TwitterConnection.get_tweets TWEETS_TO_LOAD
  tweets.each do |tweet|
    tweet.display(self)
  end
end

# main content of the window (tweets and rss feeds)
def content
  stack width: -MENU_WIDTH do
    rss_entries
    tweets
  end
end

# main infoes app
Shoes.app :title => "infoes" do
  basic_background
  title "This is infoes!", :align => "center"
  flow do
    menu
    content
  end
end

