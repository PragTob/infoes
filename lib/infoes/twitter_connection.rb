module Infoes
  module TwitterConnection
      extend YAMLSettings
      extend self

    TWITTER_URL = "https://twitter.com/#!/"
    TWITTER_API_URL = "https://api.twitter.com"
    SETTINGS_PATH = 'preferences/twitter.yml'
    DEFAULT_TWEETS_TO_LOAD = 10

    # returns the url the user has to visit in order to authorize the app
    def get_request_token
      @consumer = OAuth::Consumer.new(settings['consumer_key'],
                                      settings['consumer_secret'],
                                      :site => TWITTER_API_URL)
      @request_token = @consumer.get_request_token
      @request_token.authorize_url
    end

    def complete_authentication(pincode)
      @access_token = @request_token.get_access_token(pin: pincode)

      change_settings do |settings|
        settings['oauth_token'] = @access_token.token
        settings['oauth_secret'] = @access_token.secret
      end
    end

    def tweets_to_load=(tweets_to_load)
      change_settings { |settings| settings['tweets_to_load'] = tweets_to_load }
    end

    def tweets_to_load
      settings['tweets_to_load'] || DEFAULT_TWEETS_TO_LOAD
    end

    def already_authenticated?
      settings['oauth_token'] && settings['oauth_secret']
    end

    def tweets
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

    def load_tweets(number)
      begin
        Twitter.home_timeline[0...number].map { |tweet| Tweet.new(tweet) }
      rescue
        error "Authentication with Twitter failed."
        # our user may try and reauthenticate with Twitter
        unvalidate_authentication
        []
      end
    end

    def unvalidate_authentication
      change_settings do |settings|
        settings['oauth_token'], settings['oauth_secret'] = nil, nil
      end
    end

    def load_credentials
      Twitter.configure do |config|
        config.consumer_key = settings['consumer_key']
        config.consumer_secret = settings['consumer_secret']
        config.oauth_token = settings['oauth_token']
        config.oauth_token_secret = settings['oauth_secret']
      end
    end

    def settings_path
      SETTINGS_PATH
    end

  end
end

