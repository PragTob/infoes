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


MENU_WIDTH = 120
TWEET_PIC_WIDTH = 50

# will become a preference
TWEETS_TO_LOAD = 10
TWITTER_SIGNUP = "https://twitter.com/signup"

# the main menu displayed on the left hand side
def menu
  stack width: MENU_WIDTH do
    para link("Twitter Settings") { show_twitter_settings }
    para link("RSS feed Settings") { show_rss_settings }
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
    flow do
      # seperate stack for the images so they are displayed left
      stack width: TWEET_PIC_WIDTH, height: 60 do
        image tweet.user.profile_image_url
      end
      stack width: -TWEET_PIC_WIDTH do
        # one of those cases where {..} vs do..end actually matters
        para tweet.user.name, ": ", tweet.text, " ", link("Go to Tweet") {
          # when I got the adapter class this will simply be tweet.url
          Launchy.open(TwitterConnection::TWITTER_URL +
                      tweet.user.screen_name +
                      "/status/" +
                      tweet.id_str)
        }
      end
    end
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
  background gradient(lime, limegreen)
  title "This is infoes!", :align => "center"
  flow do
    menu
    content
  end
end

def done_button
  button("Done") { close }
end

def restart_notice
  para "Please note that you have to restart infoes in order for your changes ",
    "to take effect. This is a very early alpha version. I am sorry."
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

