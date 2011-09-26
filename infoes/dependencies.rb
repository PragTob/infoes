Shoes.setup do
  gem 'twitter'
  gem 'oauth'
  gem 'launchy'
  gem 'feedzirra'
end

require 'twitter'
require 'feedzirra'
require 'launchy'
require 'oauth'

require_relative '../lib/date_time_comparable'
require_relative '../lib/yaml_settings'
require_relative '../lib/rss_entry'
require_relative '../lib/rss_feeds'
require_relative '../lib/tweet'
require_relative '../lib/twitter_connection'
require_relative '../lib/settings'
require_relative '../lib/side_tab'

require_relative '../tabs/about'
require_relative '../tabs/general_settings'
require_relative '../tabs/home'
require_relative '../tabs/rss_settings'
require_relative '../tabs/twitter_settings'

