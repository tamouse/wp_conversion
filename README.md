# WpConversion

Convert a Wordpress XML export into pages suitable for a jekyll site

## Installation

Add this line to your application's Gemfile:

    gem 'wp_conversion'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wp_conversion

## Usage

    $ wp_conversion WPExport.xml

This will create 3 directories: `posts`, `pages`, and `attachments`
that will contain markdown files reflecting the items in the wordpress
export. The posts and pages will be converted such that a site can be
generated via jekyll.

* Posts have the YYYY-MM-DD-title.markdown format.
* Pages just have title.markdown.
* Files will have the appropriate YAML header for jekyll processing.
* Attachments will be YAML files with the link to the attachment.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
