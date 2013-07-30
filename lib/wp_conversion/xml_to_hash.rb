require 'active_support/core_ext/hash/conversions'

module WpConversion

  def self.xml_to_hash(xml)
    Hash.from_xml(xml)
  end
  
end
