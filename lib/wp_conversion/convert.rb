require 'yaml'
require 'html_massage'

module WpConversion
  
  module_function

  def convert(item,as)
    debug "convert: item: #{item.inspect}, as: #{as.inspect}"
    raise "Must specify a conversion" if as.nil?
    case as
    when :yaml
      convert_to_yaml(item)
    when :markdown
      convert_to_markdown(item)
    else
      raise "Unknown converstion: #{as.inspect}"
    end
  end
  
  def convert_to_yaml(item)
    item.to_yaml
  end

  def convert_to_markdown(item)
    return '' unless %w{page post}.include? item['post_type']
    markdown= <<-EOT
---
layout: #{item['post_type']}
author: #{item['creator']}
date: #{item['post_date']}
categories: [#{join_if_array(item['category']).tap{|t| debug "#{__FILE__}:#{__LINE__}: output of join_if_array(item['category']): #{t}"}.downcase}]
---
# #{item['title']}

EOT
    markdown += html_to_markdown(item['encoded'].join)
    # markdown.tap(&:display)

  end

  def html_to_markdown(html)
    (HtmlMassage.markdown(html.gsub(/\n/,"<br />\n")) + "\n\n").tap(&:display)
  end
  
  def join_if_array(s)
    debug "#{__FILE__}:#{__LINE__}: s: #{s.inspect}"
    if s === Array
      s.join(", ")
    else
      s.to_s
    end
  end
  
end
