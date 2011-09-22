require 'rss/2.0'
require 'open-uri'
require_relative 'rss_entry'

# Class responsible for managing and loading our RSSFeeds
class RSSFeeds

  RSS_PREFERENCES = "preferences/rss.yml"

  # load all the rss_feeds given in the RSS-Preferences.
  def self.entries
    urls.inject([]) { |rss_entries, url| rss_entries + parse_rss_entries(url) }
  end

  def self.parse_rss_entries(url)
    content = ""
    begin
      open(url) { |s| content = s.read }

      RSS::Parser.parse(content, false).items.inject([]) do |entries, rss_entry|
        entries << RSSEntry.new(rss_entry)
      end
    rescue
      error "Could not open or parse #{url} as an RSS Feed"
      # compatibility for further methods even in error cases
      []
    end
  end

  def self.add(url)
    urls << url
    change_preferences
  end

  def self.remove(url)
    urls.delete url
    change_preferences
  end

  # the feed urls
  def self.urls
    @urls || load_preferences
  end

  def self.validate_url(url)
    begin
      open(url)
    rescue
      false
    end
  end

  private

  # load the preferences file (if it exists), otherwise we don't have urls
  def self.load_preferences
    if File.exist? RSS_PREFERENCES
      File.open(RSS_PREFERENCES) { |file| @urls = YAML::load(file) }
    else
      @urls = []
    end
    @urls
  end

  # dump the new preferences into our preferences file (for now just urls)
  def self.change_preferences
    File.open RSS_PREFERENCES, 'w' do |file|
      YAML.dump(@urls, file)
    end
  end

end

