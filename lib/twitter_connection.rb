require 'twitter'
require 'oauth'
require 'yaml'
require_relative 'tweet'

class TwitterConnection

  TWITTER_URL = "https://twitter.com/#!/"
  TWITTER_API_URL = "https://api.twitter.com"
  PREFERENCES_FILE = 'preferences/twitter.yml'
  DEFAULT_TWEETS_TO_LOAD = 10

  # returns the url the user has to visit in order to authorize the app
  def self.get_request_token
    load_preferences
    @consumer = OAuth::Consumer.new(@preferences['consumer_key'],
                                    @preferences['consumer_secret'],
                                    :site => TWITTER_API_URL)
    @request_token = @consumer.get_request_token
    @request_token.authorize_url
  end

  def self.complete_authentication(pincode)
    @access_token = @request_token.get_access_token :pin => pincode

    @preferences['oauth_token'] = @access_token.token
    @preferences['oauth_secret'] = @access_token.secret
    update_preferences
  end

  def self.tweets_to_load=(tweets_to_load)
    load_preferences if @preferences.nil?
    @preferences['tweets_to_load'] = tweets_to_load
    update_preferences
  end

  def self.tweets_to_load
    @preferences['tweets_to_load'] || DEFAULT_TWEETS_TO_LOAD
  end

  def self.already_authenticated?
    @preferences['oauth_token'] && @preferences['oauth_secret']
  end

  def self.tweets
    load_credentials
    number = tweets_to_load.to_i
    if already_authenticated?
      load_tweets(number)
    else
      # if we're not authenticated, we can't show tweets
      []
    end
  end

  private

  def self.load_tweets(number)
    begin
      Twitter.home_timeline[0...number].map { |tweet| Tweet.new(tweet) }
    rescue
      error "Authentication with Twitter failed."
      # our user may try and reauthenticate with Twitter
      unvalidate_authentication
      []
    end
  end

  def self.unvalidate_authentication
    @preferences['oauth_token'], @preferences['oauth_secret'] = nil, nil
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

  def self.update_preferences
    File.open(PREFERENCES_FILE, 'w') do |file|
      YAML.dump(@preferences, file)
    end
  end

  def self.load_preferences
    File.open(PREFERENCES_FILE) do |file|
      @preferences = YAML::load(file)
    end
  end

end

