module Infoes
  module Settings
    extend YAMLSettings
    extend self

    SETTINGS_PATH = "preferences/settings.yml"

    def color=(color)
      color_hash = color_hash_from(color)
      change_settings { |settings| settings[:color] = color_hash }
    end

    def color
      color = settings[:color]
      Shoes::Color.new(color[:red], color[:green], color[:blue])
    end

    def reload_interval
      settings[:interval]
    end

    def reload_interval=(time)
      change_settings { |settings| settings[:interval] = time.to_i * 60 }
    end

    def new_dimensions(width, height)
      change_settings do |settings|
        settings[:width] = width.to_i
        settings[:height] = height.to_i
      end
    end

    def width
      settings[:width]
    end

    def height
      settings[:height]
    end

    private

    def color_hash_from(color)
      { red: color.red, blue: color.blue, green: color.green }
    end

    def settings_path
      SETTINGS_PATH
    end

  end
end

