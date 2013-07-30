require 'active_support/core_ext/hash/conversions'

module WpConversion

  module_function
  
  def xml_to_hash(xml)
    Hash.from_xml(xml)
  end
  
end
