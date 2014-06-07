require 'spec_helper'
require "recursive_open_struct"

describe KohlsTransactions do
  describe "kohls_update_coupons" do
    context "id is not existing coupon" do
      let!(:cat1) { Fabricate(:category, ls_id: 1 ) }
      let!(:cat2) { Fabricate(:category, ls_id: 5 ) }
      let!(:ctype1) { Fabricate(:ctype, ls_id: 1) }
      let!(:ctype2) { Fabricate(:ctype, ls_id: 2) }
      let!(:store1) { Fabricate(:store, id_of_store: 38605)}

      before do
        xml_response = <<-XML
          <ns1:getTextLinksResponse xmlns:ns1="http://endpoint.linkservice.linkshare.com/"><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>200334758</ns1:categoryID><ns1:categoryName>Homepage</ns1:categoryName><ns1:linkID>4134</ns1:linkID><ns1:linkName>Apparel</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.4134&amp;type=3</ns1:clickURL><ns1:endDate> </ns1:endDate><ns1:landURL>http://www.kohls.com/catalog.jsp?N=3000061747</ns1:landURL><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.4134&amp;type=3</ns1:showURL><ns1:startDate>Jun 02, 2014</ns1:startDate><ns1:textDisplay>Apparel</ns1:textDisplay></ns1:return><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>200334760</ns1:categoryID><ns1:categoryName>Men</ns1:categoryName><ns1:linkID>4135</ns1:linkID><ns1:linkName>car</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.4135&amp;type=3</ns1:clickURL><ns1:endDate>Jun 04, 2014</ns1:endDate><ns1:landURL>http://www.kohls.com/catalog/mens.jsp?CN=4294723349&amp;N=4294723349+3000061849</ns1:landURL><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.4135&amp;type=3</ns1:showURL><ns1:startDate>Jun 02, 2014</ns1:startDate><ns1:textDisplay>car</ns1:textDisplay></ns1:return><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>200334760</ns1:categoryID><ns1:categoryName>Men</ns1:categoryName><ns1:linkID>4136</ns1:linkID><ns1:linkName>Apparel</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.4136&amp;type=3</ns1:clickURL><ns1:endDate>Jun 04, 2014</ns1:endDate><ns1:landURL>http://www.kohls.com/catalog/mens.jsp?CN=4294723349&amp;N=4294723349+3000061848</ns1:landURL><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.4136&amp;type=3</ns1:showURL><ns1:startDate>Jun 02, 2014</ns1:startDate><ns1:textDisplay>Apparel</ns1:textDisplay></ns1:return></ns1:getTextLinksResponse>
        XML
        stub_request(
          :get,
          "http://lld2.linksynergy.com/services/restLinks/getTextLinks/06a400a42d5ee2822cc4342b7cedf714bffa542768b1c06d571c0ebe8aa85203/38605/-1//#{Time.now.strftime("%m%d%Y")}/-1/1"
        ).
        to_return(
          status: 200,
          body: xml_response,
          headers: { "Content-type" => "text/xml; charset=UTF-8" }
        )
        LsLinkdirectAPI.token = ENV["LINKSHARE_TOKEN"]
        KohlsTransactions.kohls_update_coupons
      end

      it "creates new coupon" do      
        expect(Coupon.count).to eq(3)
      end

      it "adds endDate if it does not exist" do
        expect(Coupon.first.end_date.strftime("%m%d%Y")).to eq('01012017')
      end

      it "adds category" do
        expect(Coupon.first.categories).to eq([cat1])
      end

      it "adds type"
      it "adds coupon to kohls_department"
      it "adds coupon to kohls_types"
      it "adds coupon to only_at_kohls"
    end
  end

  describe "find_kohls_cat" do

    it "returns category 1 for term patio" do
      expect(KohlsTransactions.find_kohls_cat('patio')).to eq([1])
    end

    it "returns category 12 for term ncaa" do
      expect(KohlsTransactions.find_kohls_cat('NCAA')).to eq([12])
    end

    it "returns category 4 if no other category is found and it is clothes" do
      expect(KohlsTransactions.find_kohls_cat('coats')).to eq([4])
    end

    it "returns multiple categories for nfl women tees" do
      expect(KohlsTransactions.find_kohls_cat('nfl women tees')).to eq([4,12])
    end

    it "returns 6 for men" do
      expect(KohlsTransactions.find_kohls_cat('men tees')).to eq([6])
    end

    it "returns nothing for garbage i am a great thing" do
      expect(KohlsTransactions.find_kohls_cat('I am a great thing')).to eq([])
    end

    it "returns category num one time for nfl ncaa" do
      expect(KohlsTransactions.find_kohls_cat('big nfl ncaa i am a player')).to eq([12])
    end
  end

  describe "find_kohls_only" do
    it "returns 1 for lauren Conrad" do
      expect(KohlsTransactions.find_kohls_only('lauren Conrad')).to eq([1])
    end

    it "returns nothing for hello world" do
      expect(KohlsTransactions.find_kohls_only('hello world')).to eq([])
    end
  end
end