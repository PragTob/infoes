require 'rss/2.0'
require 'open-uri'

class RSSFeeds

  RSS_PREFERENCES = "preferences/rss.yml"

  # load all the rss_feeds given in the RSS-Preferences.
  def self.load
    rss_feeds = []
    urls.each do |url|
      content = ""
      open(url) { |s| content = s.read }
      rss_feeds << RSS::Parser.parse(content, false)
    end
    rss_feeds
  end

  def self.add url
    @urls << url
    change_preferences
  end

  def self.remove url
    @urls.delete url
    change_preferences
  end

  def self.urls
    if @urls.nil?
      if File.exist? RSS_PREFERENCES
        load_preferences
      else
        @urls = []
      end
    end
    @urls
  end

  private
  def self.load_preferences
    File.open(RSS_PREFERENCES) do |file|
      @urls = YAML::load(file)
    end
  end

  def self.change_preferences
    File.open RSS_PREFERENCES, 'w' do |file|
      YAML.dump(@urls, file)
    end
  end

end

