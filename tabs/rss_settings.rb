require './tabs/side_tab'
require './lib/rss_feeds'

class RSSSettings < SideTab

  def content
    RSSFeeds.urls.each do |url|
      rss_feed_source url
    end

    @new_url_slot = new_rss_feed_slot
  end

  private

  # creates a new RSS feed source entry for a given url
  def rss_feed_source(url)
    this_entry = flow do
      para url, " "
      button("Remove") do
        RSSFeeds.remove url
        this_entry.clear
      end
    end
  end

  def add_feed(url)
    RSSFeeds.add url
    @content.before(@new_url_slot) do
      rss_feed_source url
    end

    @new_url_edit.text = ""
  end

  # display the slot where a user may add a new url to his rss feeds
  def new_rss_feed_slot
    flow do
      @new_url_edit = edit_line width: 300
      button("Add") do
        new_url = @new_url_edit.text
        if RSSFeeds.validate_url(new_url)
          add_feed(new_url)
        else
          alert "The url you entered doesn't seem to be valid.
                 Please verify it!"
        end
      end
    end
  end

end

