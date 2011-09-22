class Settings

  SETTINGS_PATH = "preferences/settings.yml"

  def self.color=(color)
    color_hash = color_hash(color)
    change_settings { |settings| settings[:color] = color_hash }
  end

  def self.color
    color = settings[:color]
    Shoes.rgb(color[:red], color[:green], color[:blue])
  end

  def self.reload_interval=(time)
    change_settings { |settings| settings[:interval] = time * 60 }
  end

  def self.reload_interval
    settings[:interval]
  end

  def self.reload_interval=(time)
    time = time.to_i
    change_settings { |settings| settings[:interval] = time * 60 }
  end

  def self.new_dimensions(width, height)
    change_settings do |settings|
      settings[:width] = width.to_i
      settings[:height] = height.to_i
    end
  end

  def self.width
    settings[:width]
  end

  def self.height
    settings[:height]
  end

  def self.settings
    @settings || load_settings
  end

  private

  def self.load_settings
    File.open(SETTINGS_PATH) { |file| @settings = YAML::load(file) }
    @settings
  end

  def self.save_settings
    File.open(SETTINGS_PATH, 'w') { |file| YAML.dump(@settings, file) }
  end

  def self.change_settings
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

