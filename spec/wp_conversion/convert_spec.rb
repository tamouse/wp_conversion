require 'spec_helper'
require 'yaml'

module WpConversion
  
  describe "convert.rb" do
    it {WpConversion.should respond_to(:convert)}
    it {WpConversion.should respond_to(:convert_to_yaml)}
    it {WpConversion.should respond_to(:convert_to_markdown)}
  end

  describe "conversions" do
    let(:item){
      {"title"=>"a problem with partial lines", "link"=>"http://stories.tamaratemple.com/pages/2010/05/28/a-problem-with-partial-lines/", "pubDate"=>"Sat, 29 May 2010 02:43:42 +0000", "creator"=>"tamouse", "guid"=>"http://stories.tamaratemple.com/pages/?p=130", "description"=>nil, "encoded"=>["I'm having a problem when I use the google fonts: when I scroll down or up through the document, some lines are only showing the top half of the line. If I click away, then come back, the screen repaints and the lines are fully shown. Anyone know what causes this?\n\nHere's a screenshot showing the problem:\n\n<a href=\"http://stories.tamaratemple.com/pages/wp-content/uploads/2010/05/sceen-cap-showing-partial-lines-in-safari.png\"><img class=\"alignnone size-thumbnail wp-image-131\" title=\"sceen cap showing partial lines in safari\" src=\"http://stories.tamaratemple.com/pages/wp-content/uploads/2010/05/sceen-cap-showing-partial-lines-in-safari-150x150.png\" alt=\"sceen cap showing partial lines in safari\" width=\"150\" height=\"150\" /></a>", ""], "post_id"=>"130", "post_date"=>"2010-05-28 21:43:42", "post_date_gmt"=>"2010-05-29 02:43:42", "comment_status"=>"open", "ping_status"=>"open", "post_name"=>"a-problem-with-partial-lines", "status"=>"publish", "post_parent"=>"0", "menu_order"=>"0", "post_type"=>"post", "post_password"=>nil, "is_sticky"=>"0", "category"=>"Uncategorized", "postmeta"=>{"meta_key"=>"_edit_last", "meta_value"=>"2"}, "comment"=>{"comment_id"=>"2", "comment_author"=>"tamouse", "comment_author_email"=>"tamouse@gmail.com", "comment_author_url"=>"http://tamaratemple.com/", "comment_author_IP"=>"71.193.74.221", "comment_date"=>"2010-05-29 02:01:26", "comment_date_gmt"=>"2010-05-29 07:01:26", "comment_content"=>"Okay, fixed that by using a different font. Cando was the culprit, now using 'OFL Sorts Mill Goudy TT'", "comment_approved"=>"1", "comment_type"=>nil, "comment_parent"=>"0", "comment_user_id"=>"2"}}
    }


    describe "convert" do
      it "should select the right conversion for yaml" do
        WpConversion.should_receive(:convert_to_yaml).and_return(true)
        WpConversion.should_not_receive(:convert_to_markdown)
        WpConversion.convert(item,:yaml).should be_true
      end
      
      it "should select the right conversion for markdown" do
        WpConversion.should_receive(:convert_to_markdown).and_return(true)
        WpConversion.should_not_receive(:convert_to_yaml)
        WpConversion.convert(item,:markdown).should be_true
      end
      
      it "should throw and error when an invalid conversion is used" do
        WpConversion.should_not_receive(:convert_to_yaml)
        WpConversion.should_not_receive(:convert_to_markdown)
        expect {WpConversion.convert(item,:junk)}.to raise_exception
      end
    end

    describe "convert_to_yaml" do
      let(:yaml) {WpConversion.convert_to_yaml(item)}
      it {yaml.should be_a(String)}
      it {yaml.should match /^---\ntitle: #{item['title']}\nlink: #{item['link']}/}
      it "should match item when unylized" do
        YAML.load(yaml).should == item
      end

    end

    describe "convert_to_markdown" do
      let(:markdown) {WpConversion.convert_to_markdown(item)}
      it {markdown.should be_a(String)}
      it {markdown.should match /^---\nlayout: #{item['post_type']}\ntitle:.*\nauthor: #{item['creator']}\ndate: #{item['post_date']}\ntags: \[#{item['category'].downcase}\]\n---/}
    end

  end

  describe "convert php serialized data" do
    let(:data){"a:6:{s:5:\"width\";s:4:\"2321\";s:6:\"height\";s:4:\"1677\";s:14:\"hwstring_small\";s:23:\"height='92' width='128'\";s:4:\"file\";s:30:\"2012/02/zigzag.riversketch.jpg\";s:5:\"sizes\";a:6:{s:9:\"thumbnail\";a:3:{s:4:\"file\";s:30:\"zigzag.riversketch-150x150.jpg\";s:5:\"width\";s:3:\"150\";s:6:\"height\";s:3:\"150\";}s:6:\"medium\";a:3:{s:4:\"file\";s:30:\"zigzag.riversketch-300x216.jpg\";s:5:\"width\";s:3:\"300\";s:6:\"height\";s:3:\"216\";}s:5:\"large\";a:3:{s:4:\"file\";s:31:\"zigzag.riversketch-1024x739.jpg\";s:5:\"width\";s:4:\"1024\";s:6:\"height\";s:3:\"739\";}s:14:\"post-thumbnail\";a:3:{s:4:\"file\";s:31:\"zigzag.riversketch-1000x288.jpg\";s:5:\"width\";s:4:\"1000\";s:6:\"height\";s:3:\"288\";}s:13:\"large-feature\";a:3:{s:4:\"file\";s:31:\"zigzag.riversketch-1000x288.jpg\";s:5:\"width\";s:4:\"1000\";s:6:\"height\";s:3:\"288\";}s:13:\"small-feature\";a:3:{s:4:\"file\";s:30:\"zigzag.riversketch-415x300.jpg\";s:5:\"width\";s:3:\"415\";s:6:\"height\";s:3:\"300\";}}s:10:\"image_meta\";a:10:{s:8:\"aperture\";s:1:\"0\";s:6:\"credit\";s:0:\"\";s:6:\"camera\";s:0:\"\";s:7:\"caption\";s:0:\"\";s:17:\"created_timestamp\";s:1:\"0\";s:9:\"copyright\";s:0:\"\";s:12:\"focal_length\";s:1:\"0\";s:3:\"iso\";s:1:\"0\";s:13:\"shutter_speed\";s:1:\"0\";s:5:\"title\";s:0:\"\";}}"}
    let(:un_data){WpConversion.php_unserialize(data)}
    it "should return unserialized data" do
      un_data.should be_a Hash
    end

  end

  describe "convert item with php serialized data" do
    let(:item_with_php_serialize_data){
      {"title"=>"Last post?",
        "link"=>"http://www.tamaratemple.com/2013/05/14/last-post/",
        "pubDate"=>"Wed, 15 May 2013 04:56:21 +0000",
        "creator"=>"tamouse",
        "guid"=>"http://tamouse.org/?p=3701",
        "description"=>nil,
        "encoded"=>
        ["This might be the last post from here. I'm having all sorts of troubles with comment spammers, ddos attacks on our VPS, port scans and probes.  It's all become too much, and it bogs down the system so it becomes so frustrating to work with. Doing this, running my own server, blogs, wikis, email and so on has been sorta fun. But I think it's time I moved on from that. This may resurface on tublr or something, if I feel like it.\n\nThis blog (as well as the others I've been running) has never really developed any sort of audience, and certainly not generated any sort of interest, community, or even communication. So it's not really doing much of anything anyway.\n\nIf you are a reader, of any stripe, post a comment, give me some feedback via the contact form, or send me an <a href=\"mailto:tamara@tamaratemple.com\">email</a>. It'd be good to hear from you; let me know what direction if any I should go in.",
         ""],
        "post_id"=>"3701",
        "post_date"=>"2013-05-14 23:56:21",
        "post_date_gmt"=>"2013-05-15 04:56:21",
        "comment_status"=>"open",
        "ping_status"=>"open",
        "post_name"=>"last-post",
        "status"=>"publish",
        "post_parent"=>"0",
        "menu_order"=>"0",
        "post_type"=>"post",
        "post_password"=>nil,
        "is_sticky"=>"0",
        "category"=>"Uncategorized",
        "postmeta"=>
        [{"meta_key"=>"_edit_last", "meta_value"=>"1"},
         {"meta_key"=>"_jp_jpics",
           "meta_value"=>
           "a:3:{i:1;s:4:\"tree\";i:3;s:15:\"colourful trees\";i:2;s:6:\"mousie\";}"}]}
    }
    let(:yamlized_item){WpConversion.convert_to_yaml(item_with_php_serialize_data)}
    let(:unyamlized_item){YAML.load(yamlized_item)}
    it {yamlized_item.should be_a String}
    it {unyamlized_item.should be_a Hash}
    it {unyamlized_item.should have_key "postmeta"}
    it {unyamlized_item["postmeta"].should be_an Array}
    it {unyamlized_item["postmeta"].size.should == 2}
    it {unyamlized_item["postmeta"].last.should have_key "meta_value"}
    it {unyamlized_item["postmeta"].last["meta_value"].should be_a Hash}
    it {unyamlized_item["postmeta"].last["meta_value"]["1"].should eq "tree"}
    it {unyamlized_item["postmeta"].last["meta_value"]["3"].should eq "colourful trees"}
    it {unyamlized_item["postmeta"].last["meta_value"]["2"].should eq "mousie"}
  end

  describe "clean and convert tags" do
    it {WpConversion.clean_tags('sometag').should eq 'sometag'}
    it {WpConversion.clean_tags('@sometag').should eq 'sometag'}
    it {WpConversion.clean_tags('#sometag').should eq 'sometag'}
    it {WpConversion.clean_tags('some tag').should eq 'sometag'}
    it {WpConversion.clean_tags(['sometag', 'some other tag', '&another tag']).should eq ['sometag','someothertag','anothertag']}
  end

  describe "join tags correctly" do
    it {WpConversion.join_if_array('not an array').should eq 'not an array'}
    it {WpConversion.join_if_array(%w{is an array}).should eq 'is, an, array'}
  end


end
