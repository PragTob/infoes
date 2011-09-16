require 'twitter'

# my adapter for twitter gem tweets
class Tweet

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
end

