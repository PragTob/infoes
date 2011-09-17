require 'rss/2.0'

# adapter for rss entries
class RSSEntry

  attr_reader :title, :url, :date_time

  # initialize given the feed object
  def initialize(feed_entry)
    @title = feed_entry.title
    @url = feed_entry.link
    @date_time = feed_entry.pubDate
  end

  def display(shoes)
    shoes.para title, " ", shoes.link("Go to Post") { Launchy.open url }
  end
end

