module Infoes

  # my adapter for twitter gem tweets
  class Tweet
    include DateTimeComparable

    TWEET_PIC_WIDTH = 50
    TWITTER_URL = "https://twitter.com/#!/"

    attr_reader :publisher_name, :publisher_display_name, :url, :text, :image_url,
      :date_time

    # initialize using a tweet object from the Twitter gem
    def initialize(tweet)
      @publisher_name = tweet.user.name
      @publisher_display_name = tweet.user.display_name
      @text = tweet.text
      @image_url = tweet.user.profile_image_url
      @url =  TwitterConnection::TWITTER_URL +
              tweet.user.screen_name +
              "/status/" +
              tweet.id_str
      @date_time = Time.parse(tweet.created_at)
    end

    # we need the shoes object in order to display our tweets
    def display(shoes)
      shoes.flow do
        # seperate stack for the images so they are displayed left
        shoes.stack width: TWEET_PIC_WIDTH, height: 60 do
          shoes.image(image_url)
        end
        shoes.stack width: -TWEET_PIC_WIDTH do
          # green shoes compatibility, maybe let green_maker insert this...
          text.gsub!('&', '&amp;')
          shoes.para publisher_name, ": ", text, " ", date_time, " ",
            shoes.link("Go to Tweet") { Launchy.open(url) }
        end
      end
    end

  end

end

