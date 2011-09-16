require 'twitter'

# my adapter for twitter gem tweets
class Tweet

  TWEET_PIC_WIDTH = 50

  TWITTER_URL = "https://twitter.com/#!/"

  attr_reader :publisher_name, :publisher_display_name, :url, :text, :image_url

  # initialize using a tweet object from the Twitter gem
  def initialize(tweet)
    @publisher_name = tweet.user.name
    @publisher_display_name = tweet.user.display_name
    @text = tweet.text
    @image_url = tweet.user.profile_image_url
    @url =  TwitterConnection::TWITTER_URL +
            tweet.user.screen_name +
            "/status/" +
            tweet.id_str
    info tweet.inspect
  end

  # we need the shoes object in order to display our objects
  def display(shoes)
    shoes.flow do
      # seperate stack for the images so they are displayed left
      shoes.stack width: TWEET_PIC_WIDTH, height: 60 do
        shoes.image image_url
      end
      shoes.stack width: -TWEET_PIC_WIDTH do
        shoes.para publisher_name, ": ", text, " ",
          shoes.link("Go to Tweet") { Launchy.open(url) }
      end
    end
  end

end

## How do we display tweets in shoes?
#module TweetDisplay

#  def display_tweet(tweet)
#    para tweet.text
#  end

#end

