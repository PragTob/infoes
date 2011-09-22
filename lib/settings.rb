class Settings

  SETTINGS_PATH = "preferences/settings.yml"

  def self.color=(color)
    color_hash = color_hash(color)
    settings { |settings| settings[:color] = color_hash }
  end

  def self.color
    load_settings
    color = @settings[:color]
    Shoes.rgb(color[:red], color[:green], color[:blue])
  end

  def self.reload_interval=(time)
    settings { |settings| settings[:interval] = time * 60 }
  end

  def self.reload_interval
    load_settings
    @settings[:interval]
  end

  def self.reload_interval=(time)
    time = time.to_i
    settings { |settings| settings[:interval] = time * 60 }
  end

  def self.new_dimensions(width, height)
    settings do |settings|
      settings[:width] = width.to_i
      settings[:height] = height.to_i
    end
  end

  def self.width
    load_settings
    @settings[:width]
  end

  def self.height
    load_settings
    @settings[:height]
  end

  private

  def self.load_settings
    File.open(SETTINGS_PATH) { |file| @settings = YAML::load(file) }
  end

  def self.save_settings
    File.open(SETTINGS_PATH, 'w') { |file| YAML.dump(@settings, file) }
  end

  def self.settings
    load_settings
    yield @settings
    save_settings
  end

  def self.color_hash(color)
    c_hash = {}
    c_hash[:red] = color.red
    c_hash[:blue] = color.blue
    c_hash[:green] = color.green
    c_hash
  end

end

