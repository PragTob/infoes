module SimpleOAuth
  class Header
    ATTRIBUTE_KEYS = [:callback, :consumer_key, :consumer_secret, :nonce, :signature_method, :timestamp, :token, :token_secret, :verifier, :version]
  end
end

require 'simple_oauth'
require 'faraday'
require 'faraday_middleware'
require 'twitter'

module Infoes
  module TwitterConnection
      extend YAMLSettings
      extend self

    TWITTER_URL = "https://twitter.com/#!/"
    TWITTER_API_URL = "https://api.twitter.com"
    SETTINGS_PATH = 'preferences/twitter.yml'
    DEFAULT_TWEETS_TO_LOAD = 10

    # TODO: we could iterate through connection apps and modify options?
    def new_settings(options = {})
      @connection = nil # build new faraday connection to read the new settings
      change_settings{|s| s.merge!(options) }
    end

    def connection
      @connection ||=
      Faraday.new(TWITTER_API_URL) do |connection|
        connection.request :oauth, settings
        connection.adapter Faraday.default_adapter
      end
    end

    # returns the url the user has to visit in order to authorize the app
    def get_authorize_url
      response = connection.post("/oauth/request_token")
      "#{TWITTER_API_URL}/oauth/authorize?oauth_token=#{parse_params(response.body)[:oauth_token]}"
    end

    def parse_params(str)
      Hash[
        str.split(/&/).map do |s|
          matches = /^([^=]+)=(.*)$/.match(s)
          matches and matches.captures
        end.compact.map do |k,v|
          [k.to_sym, v]
        end
      ]
    end

    def complete_authentication(pincode)
      return if pincode.nil?

      new_settings(verifier: pincode)

      response = connection.post("/oauth/request_token")
      params = parse_params(response.body)

      new_settings(
        token:        params[:oauth_token],
        token_secret: params[:oauth_token_secret],
        verifier:     nil
      )

      response = connection.get("/oauth/authorize")
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
      @client.home_timeline[0...number].map { |tweet| Tweet.new(tweet) }
    rescue
      error "Authentication with Twitter failed."
      # our user may try and reauthenticate with Twitter
      unvalidate_authentication
      []
    end

    def unvalidate_authentication
      change_settings do |settings|
        settings['oauth_token'], settings['oauth_secret'] = nil, nil
      end
    end

    def load_credentials
      @client =
      Twitter::REST::Client.new do |config|
        config.consumer_key        = settings['consumer_key']
        config.consumer_secret     = settings['consumer_secret']
        config.access_token        = settings['oauth_token']
        config.access_token_secret = settings['oauth_secret']
      end
    rescue
      error "Authentication with Twitter failed."
      # our user may try and reauthenticate with Twitter
      unvalidate_authentication
      []
    end

    def settings_path
      SETTINGS_PATH
    end

  end
end

