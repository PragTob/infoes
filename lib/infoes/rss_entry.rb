module Infoes
  class RSSEntry
    include DateTimeComparable

    attr_reader :title, :url, :date_time

    def initialize(feed_entry)
      @title = feed_entry.title
      @url = feed_entry.url
      # RSS vs. Atom
      @date_time = feed_entry.published
    end

    def display(shoes)
      shoes.para title, " ", date_time, " ",
        shoes.link("Go to Post") { Launchy.open(url) }
    end

  end
end

