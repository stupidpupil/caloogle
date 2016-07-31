require 'settingslogic'

module Caloogle
  class Config < Settingslogic
    source File.expand_path('../../../config/config.yaml', __FILE__)
    namespace ENV['RACK_ENV'] || 'development'

  end
end

