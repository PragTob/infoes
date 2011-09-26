require 'yaml'

module YAMLSettings

  def save_settings(_settings)
    File.open(settings_path, 'w') { |file| YAML.dump(_settings, file) }
  end

  def load_settings
    File.open(settings_path) { |file| YAML::load(file) }
  end

  def change_settings
    _settings = load_settings
    yield _settings
    save_settings(_settings)
  end

end

