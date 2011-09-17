require './lib/ui/side_tab.rb'

# requires are strange but require_relative throws "Can't infer basepath errors"
require './lib/rss'
require './lib/twitter'
require './lib/tweet'


class Home < SideTab

  def content
    items = []
    items.concat(RSSFeeds.entries).concat(TwitterConnection.tweets)
    items.sort.reverse.each { |each| each.display(self) }
  end

end

