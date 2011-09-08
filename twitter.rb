# our twitter part

require 'twitter'
require 'oauth'
require 'yaml'

def load_tweets
  credentials = YAML::load(File.open('credentials.yml'))
end

