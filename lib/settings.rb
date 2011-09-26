module Settings
  extend self

  SETTINGS_PATH = "preferences/settings.yml"

  def color=(color)
    color_hash = color_hash_from(color)
    change_settings { |settings| settings[:color] = color_hash }
  end

  def color
    color = settings[:color]
    Shoes.rgb(color[:red], color[:green], color[:blue])
  end

  def reload_interval=(time)
    change_settings { |settings| settings[:interval] = time * 60 }
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

  def settings
    @settings || load_settings
  end

  private

  def load_settings
    File.open(SETTINGS_PATH) { |file| @settings = YAML::load(file) }
    @settings
  end

  def save_settings
    File.open(SETTINGS_PATH, 'w') { |file| YAML.dump(@settings, file) }
  end

  def change_settings
    load_settings
    yield @settings
    save_settings
  end

  def color_hash_from(color)
    { red: color.red, blue: color.blue, green: color.green }
  end

end

