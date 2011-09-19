# our twitter part

require 'twitter'
require 'oauth'
require 'yaml'
require_relative 'tweet'

# Our connection to Twitter
# All methods are class side since this is only for one user
# no need for an instance
class TwitterConnection

  TWITTER_URL = "https://twitter.com/#!/"
  TWITTER_API_URL = "https://api.twitter.com"
  PREFERENCES_FILE = 'preferences/twitter.yml'
  DEFAULT_TWEETS_TO_LOAD = 10

  def self.update_preferences
    File.open PREFERENCES_FILE, 'w' do |file|
      YAML.dump(@preferences, file)
    end
  end

  def self.load_preferences
    File.open(PREFERENCES_FILE) do |file|
      @preferences = YAML::load(file)
    end
  end

  # gets the request token
  # returns the url the user has to visit in order to authorize the app
  def self.get_request_token
    load_preferences
    @consumer = OAuth::Consumer.new(@preferences['consumer_key'],
                                    @preferences['consumer_secret'],
                                    :site => TWITTER_API_URL)
    @request_token = @consumer.get_request_token
    @request_token.authorize_url
  end

  # complete the authentication with the pincode
  def self.complete_authentication(pincode)
    @access_token = @request_token.get_access_token :pin => pincode

    # save the access token to our yaml file
    @preferences['oauth_token'] = @access_token.token
    @preferences['oauth_secret'] = @access_token.secret
    update_preferences
  end

  # load the preferences and configure the twitter gem to use them
  def self.load_credentials
    load_preferences
    Twitter.configure do |config|
      config.consumer_key = @preferences['consumer_key']
      config.consumer_secret = @preferences['consumer_secret']
      config.oauth_token = @preferences['oauth_token']
      config.oauth_token_secret = @preferences['oauth_secret']
    end
  end

  def self.tweets_to_load=(tweets_to_load)
    load_preferences if @preferences.nil?
    @preferences['tweets_to_load'] = tweets_to_load
    update_preferences
  end

  def self.tweets_to_load
    @preferences['tweets_to_load'] || DEFAULT_TWEETS_TO_LOAD
  end

  # Determine whether the user is already authenticated with infoes
  # therefore check for the presence of the user specific token and secret
  def self.already_authenticated?
    @preferences['oauth_token'] && @preferences['oauth_secret']
  end

  def self.tweets
    load_credentials
    number = tweets_to_load.to_i
    if already_authenticated?
      Twitter.home_timeline[0...number].map { |tweet| Tweet.new(tweet) }
    else
      # if we're not authenticated, we can't show tweets
      []
    end
  end

end

