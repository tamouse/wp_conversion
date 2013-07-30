require "methadone"

Dir[File.join(File.expand_path('../', __FILE__),'**','*.rb')].each {|file| require file}

module WpConversion
  extend Methadone::CLILogging
end
