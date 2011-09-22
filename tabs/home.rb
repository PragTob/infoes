require './tabs/side_tab.rb'

# requires are strange but require_relative throws "Can't infer basepath errors"
require './lib/rss_feeds'
require './lib/twitter_connection'
require './lib/settings'

class Home < SideTab

  def content
    items = []
    items.concat(RSSFeeds.entries).concat(TwitterConnection.tweets)
    every(Settings.reload_interval) { clear { content } }
    items.sort.reverse.each { |each| each.display(self) }
  end

end

