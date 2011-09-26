require 'feedzirra'
require 'open-uri'
require 'yaml'
require_relative 'rss_entry'
require_relative 'yaml_settings'

# Class responsible for managing and loading our RSSFeeds
module RSSFeeds
  extend YAMLSettings
  extend self

  RSS_PREFERENCES = "preferences/rss.yml"

  # load all the rss_feeds given in the RSS-Preferences.
  def entries
    settings.inject([]) do |rss_entries, url|
      rss_entries + parse_rss_entries(url)
    end
  end

  def add(url)
    change_settings { |settings| settings << url }
  end

  def remove(url)
    change_settings { |settings| settings.delete(url) }
  end

  def validate_url(url)
    begin
      open(url)
    rescue
      false
    end
  end

  def urls
    settings
  end

  private

  # load the preferences file (if it exists), otherwise we don't have urls
  # TODO: create the file and commit it to the repo
  def load_preferences
    if File.exist?(RSS_PREFERENCES)
      settings
    else
      []
    end
  end

  def parse_rss_entries(url)
    begin
      Feedzirra::Feed.fetch_and_parse(url).entries.inject([]) do
        |entries, rss_entry|
        entries << RSSEntry.new(rss_entry)
      end
    rescue
      error "Could not open or parse #{url} as an RSS Feed"
      # compatibility for further methods even in error cases
      []
    end
  end

  def settings_path
    RSS_PREFERENCES
  end

end

