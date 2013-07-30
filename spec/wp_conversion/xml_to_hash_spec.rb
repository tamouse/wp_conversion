module WpConversion

  describe "#xml_to_hash method" do
    it {WpConversion.should respond_to :xml_to_hash}

    context "converting xml" do
      let(:xml){'<?xml version="1.0"?><catalog><book id="bk001"><author>Gaiman, Neil</author><title>The Graveyard Book</title><genre>Fantasy</genre></book><book id="bk002"><author>Pratchett, Terry</author><title>The Colour of Magic</title><genre>fantasy</genre></book></catalog> '}
      let(:hash){WpConversion.xml_to_hash(xml)}
      it {hash.should be_a(Hash)}
      it {hash.keys.count.should == 1}
      it {hash.keys.should include("catalog")}
      context "catalog" do
        let(:books){hash['catalog']['book']}
        it {books.should be_a(Array)}
        it {books.size.should == 2}
        context "books.first" do
          let(:first_book){books.first}
          it {first_book.should be_a(Hash)}
          %w{id author title genre}.each do |attr|
            it {first_book.has_key?(attr).should be_true}
          end
        end
      end
      
    end
  end
end
