# our twitter part

require 'twitter'
require 'oauth'
require 'yaml'

TWITTER_API_URL = "https://api.twitter.com"

# gets the request token and returns the url the user has to visit in order to authorize the app
def get_request_token
  credentials = YAML::load(File.open('credentials.yml'))
  @consumer = OAuth::Consumer.new(credentials['consumer_key'], credentials['consumer_secret'], :site => TWITTER_API_URL)
  @request_token = @consumer.get_request_token
  @request_token.authorize_url
end

def complete_authentication pincode
  @access_token = @request_token.get_access_token :pin => pincode
end

