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
    if item.has_key? 'postmeta'
      process_indifferently item['postmeta'] do |meta_item|
        debug "convert_to_yaml #{__LINE__}: meta_item: #{meta_item.inspect}"
        if meta_item['meta_value'] =~ /^[:alpha:]:\d:/
          meta_item['meta_value'] = php_unserialize(meta_item['meta_value']).tap{|t| debug "convert_to_yaml #{__LINE__}: php_unserialize: #{t.inspect}"}
        end
      end
    end
    item.to_yaml
  end

  def convert_to_markdown(item)
    return '' unless %w{page post}.include? item['post_type']
    unless item['title'].nil?
      title = item['title'].gsub(%r{:},'-') # funny things happen with
      # colons in yaml entries....
    else
      title = 'unnamed'
    end
    tags = join_if_array(clean_tags(item['category'])).downcase
    markdown= <<-EOT
---
layout: #{item['post_type']}
title: #{title}
author: #{item['creator']}
date: #{item['post_date']}
tags: [#{tags}]
---
#{html_to_markdown(item['encoded'].join)}
EOT
  end

  def html_to_markdown(html)
    HtmlMassage.markdown(html.gsub(/\n/,"<br />\n")) + "\n\n"
  end
  
  def clean_tags(s)
    alnum_only = %r{[^[:alnum:]]}    
    process_indifferently(s) do |tag|
      tag.gsub!(alnum_only,'')
    end
    s.tap{|t| debug "clean_tags #{__LINE__}: return: #{t.inspect}"}
  end

  def join_if_array(s)
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
