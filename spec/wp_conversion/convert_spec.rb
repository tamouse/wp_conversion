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
      it {markdown.should match /^---\nlayout: #{item['post_type']}\nauthor: #{item['creator']}\ndate: #{item['post_date']}\ncategories: \[#{item['category'].downcase}\]\n---/}
      it {markdown.should match /---\n# #{item['title']}\n\n/}
    end

  end

end