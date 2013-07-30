require 'spec_helper'
require 'tmpdir'

module WpConversion

  describe "verify methods exist" do
    it {WpConversion.should respond_to(:save_items)}
    it {WpConversion.should respond_to(:save_file_name)}
    it {WpConversion.should respond_to(:save_an_item)}
  end
  
  describe "save items" do
    let(:items) do
      [{"title"=>"a problem with partial lines", "link"=>"http://stories.tamaratemple.com/pages/2010/05/28/a-problem-with-partial-lines/", "pubDate"=>"Sat, 29 May 2010 02:43:42 +0000", "creator"=>"tamouse", "guid"=>"http://stories.tamaratemple.com/pages/?p=130", "description"=>nil, "encoded"=>["I'm having a problem when I use the google fonts: when I scroll down or up through the document, some lines are only showing the top half of the line. If I click away, then come back, the screen repaints and the lines are fully shown. Anyone know what causes this?\n\nHere's a screenshot showing the problem:\n\n<a href=\"http://stories.tamaratemple.com/pages/wp-content/uploads/2010/05/sceen-cap-showing-partial-lines-in-safari.png\"><img class=\"alignnone size-thumbnail wp-image-131\" title=\"sceen cap showing partial lines in safari\" src=\"http://stories.tamaratemple.com/pages/wp-content/uploads/2010/05/sceen-cap-showing-partial-lines-in-safari-150x150.png\" alt=\"sceen cap showing partial lines in safari\" width=\"150\" height=\"150\" /></a>", ""], "post_id"=>"130", "post_date"=>"2010-05-28 21:43:42", "post_date_gmt"=>"2010-05-29 02:43:42", "comment_status"=>"open", "ping_status"=>"open", "post_name"=>"a-problem-with-partial-lines", "status"=>"publish", "post_parent"=>"0", "menu_order"=>"0", "post_type"=>"post", "post_password"=>nil, "is_sticky"=>"0", "category"=>"Uncategorized", "postmeta"=>{"meta_key"=>"_edit_last", "meta_value"=>"2"}, "comment"=>{"comment_id"=>"2", "comment_author"=>"tamouse", "comment_author_email"=>"tamouse@gmail.com", "comment_author_url"=>"http://tamaratemple.com/", "comment_author_IP"=>"71.193.74.221", "comment_date"=>"2010-05-29 02:01:26", "comment_date_gmt"=>"2010-05-29 07:01:26", "comment_content"=>"Okay, fixed that by using a different font. Cando was the culprit, now using 'OFL Sorts Mill Goudy TT'", "comment_approved"=>"1", "comment_type"=>nil, "comment_parent"=>"0", "comment_user_id"=>"2"}}]
    end
    let(:write_contents) do
      <<-EOT
---
layout: post
title: a problem with partial lines
date: 2010-05-28 02:43
author: tamouse
---
I'm having a problem when I use the google fonts: when I scroll down or up through the document, some lines are only showing the top half of the line. If I click away, then come back, the screen repaints and the lines are fully shown. Anyone know what causes this?

Here's a screenshot showing the problem:

![screen cap showing partial lines in safari](http://stories.tamaratemple.com/pages/wp-content/uploads/2010/05/sceen-cap-showing-partial-lines-in-safari-150x150.png)
EOT
    end

    context "#save_file_name" do
      it "returns a parameterized file name with no extension given the item" do
        WpConversion.save_file_name(items.first).should == "posts/2010-05-28-a-problem-with-partial-lines."
      end
      it "returns a parameterized file name with an extension given the item" do
        WpConversion.save_file_name(items.first,'markdown').should == "posts/2010-05-28-a-problem-with-partial-lines.markdown"
      end
    end

    context "#save_an_item" do
      it "saves the item" do
        File.should_receive(:write).and_return(write_contents)
        WpConversion.should_receive(:convert).and_return(write_contents)
        output = WpConversion.save_an_item(items.first)
        output.should be_a(String)
        output.should == write_contents
      end
    end

  end

end
