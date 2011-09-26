require './tabs/side_tab.rb'

# requires are strange but require_relative throws "Can't infer basepath errors"
require './lib/rss_feeds'
require './lib/twitter_connection'
require './lib/settings'

module Infoes

  class Home < SideTab

    def content
      refresh_utils
      items = []
      items.concat(RSSFeeds.entries).concat(TwitterConnection.tweets)
      items.sort.reverse.each { |each| each.display(self) }
    end

    private

    def refresh_utils
      every(Settings.reload_interval) { clear { content } }
      flow do
        button "Refresh" do
          clear { content }
        end
        inscription "(This will automatically happen every " +
                    "#{Settings.reload_interval / 60} minutes)"
      end
    end

  end

end

