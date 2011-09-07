require 'rss/2.0'
require 'open-uri'

# load an RSS-feed
def load_rss url
  source = url
  content = "" # raw content of rss feed will be loaded here
  open(source) { |s| content = s.read }
  RSS::Parser.parse(content, false)
end

