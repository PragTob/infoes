require 'yaml'

module Infoes
  module YAMLSettings

    def save_settings
      File.open(settings_path, 'w') { |file| YAML.dump(@settings, file) }
    end

    def load_settings
      File.open(settings_path) { |file| @settings = YAML::load(file) }
      @settings
    end

    def change_settings
      yield settings
      save_settings
    end

    def settings
      @settings || load_settings
    end

  end

end

