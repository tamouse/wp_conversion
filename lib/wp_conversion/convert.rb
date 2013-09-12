require 'yaml'
require 'json'
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
    process_indifferently item['postmeta'] do |meta_item|
      debug "convert_to_yaml: meta_item: #{meta_item.inspect}"
      if meta_item['meta_value'] =~ /^[:alpha:]:[:digit:]:/
        meta_item['meta_value'] = php_unserialize(meta_item['meta_value'])
      end
    end
    item.to_yaml
  end

  def convert_to_markdown(item)
    return '' unless %w{page post}.include? item['post_type']
    markdown= <<-EOT
---
layout: #{item['post_type']}
title: #{item['title'].gsub(/:/,'-')}
author: #{item['creator']}
date: #{item['post_date']}
tags: [#{join_if_array(item['category']).downcase}]
---
#{html_to_markdown(item['encoded'].join)}
EOT
  end

  def html_to_markdown(html)
    HtmlMassage.markdown(html.gsub(/\n/,"<br />\n")) + "\n\n"
  end
  
  def join_if_array(s)
    debug "#{__FILE__}:#{__LINE__}: s: #{s.inspect}"
    if s.kind_of? Array
      s.join(", ")
    else
      s.to_s
    end
  end
  
  def process_indifferently(obj)
    if obj.kind_of? Array
      obj.each do |item|
        yield item
      end
    else
      yield obj
    end
  end

  def php_unserialize(s)
    script = "<?php echo json_encode(unserialize(#{s.inspect}));"
    un_s, status = Open3.capture2e("php", :stdin_data => script)
    raise "php unserialize failure: #{status.exitstatus}: #{un_s.inspect}" unless status.success?

    JSON.parse(un_s)
  end

end
