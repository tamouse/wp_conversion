require 'active_support/core_ext/string/inflections.rb'
require 'fileutils'
require 'stringex'

module WpConversion

  module_function

  def save_items(items,as=:yaml)
    items.each{|item| save_an_item(item,as)}
  end

  def save_an_item(item,as=:yaml)
    File.write(save_file_name(item,as.to_s), convert(item,as))
  end
  
  def save_file_name(item, ext='')
    dir_name = item['post_type'].pluralize
    FileUtils.mkdir_p(dir_name) unless File.directory? dir_name
    
    prefix = (item['post_type'] == 'post' ?
              item['post_date'].split(" ").first + '-':
              ''
              )
    slug = make_slug(item)
    File.join(dir_name, "#{prefix}#{slug}.#{ext}")
  end

  def make_slug(item)
    return item['post_name'] unless item['post_name'].nil? || item['post_name'].empty?
    return item['title'].to_url unless item['title'].nil? || item['title'].empty?
    "unnamed"
  end



end
