file_spec = File.join(File.expand_path('../', __FILE__),'**','*.rb')
Dir[file_spec].each {|file| require file}

module WpConversion

  def self.run(wp_xml, options={})
  end

end
