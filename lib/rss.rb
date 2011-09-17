# Class responsible for managing and loading our RSSFeeds

require 'rss/2.0'
require 'open-uri'
require_relative 'rss_entry'

class RSSFeeds
  RSS_PREFERENCES = "preferences/rss.yml"

  # load all the rss_feeds given in the RSS-Preferences.
  def self.entries
    rss_entries = []
    urls.each do |url|
      content = ""
      open(url) { |s| content = s.read }
      RSS::Parser.parse(content, false).items.each do |rss_entry|
        rss_entries << RSSEntry.new(rss_entry)
      end
    end
    rss_entries
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

  private

  # load the preferences file (if it exists), otherwise we don't have urls
  def self.load_preferences
    if File.exist? RSS_PREFERENCES
      File.open(RSS_PREFERENCES) { |file| @urls = YAML::load(file) }
    else
      @urls = []
    end
  end

  # dump the new preferences into our preferences file (for now just urls)
  def self.change_preferences
    File.open RSS_PREFERENCES, 'w' do |file|
      YAML.dump(@urls, file)
    end
  end

end

