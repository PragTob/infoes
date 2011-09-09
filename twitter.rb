# our twitter part

require 'twitter'
require 'oauth'
require 'yaml'

TWITTER_API_URL = "https://api.twitter.com"
CREDENTIALS_FILE = 'preferences/twitter_credentials.yml'

# Our connection Twitter
# All methods are class side since this is only for one user, no need for an instance
class TwitterConnection
  # gets the request token and returns the url the user has to visit in order to authorize the app
  def self.get_request_token
    load_credentials_file
    @consumer = OAuth::Consumer.new(@credentials['consumer_key'], @credentials['consumer_secret'], :site => TWITTER_API_URL)
    @request_token = @consumer.get_request_token
    @request_token.authorize_url
  end

  # complete the authentication with the pincode (as retrieved by the GUI)
  def self.complete_authentication pincode
    @access_token = @request_token.get_access_token :pin => pincode

    # save the access token to our yaml file
    @credentials['oauth_token'] = @access_token.token
    @credentials['oauth_secret'] = @access_token.secret
    File.open CREDENTIALS_FILE, 'w' do |file|
      YAML.dump(@credentials, file)
    end
  end

  def self.load_credentials_file
    File.open(CREDENTIALS_FILE) do |file|
      @credentials = YAML::load(file)
    end
  end

  def self.load_credentials
    load_credentials_file
    Twitter.configure do |config|
      config.consumer_key = @credentials['consumer_key']
      config.consumer_secret = @credentials['consumer_secret']
      config.oauth_token = @credentials['oauth_token']
      config.oauth_token_secret = @credentials['oauth_secret']
    end
  end

  def self.get_tweets number
    load_credentials if @credentials.nil?
    Twitter.home_timeline[0..number]
  end

end

