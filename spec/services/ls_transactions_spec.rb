require 'spec_helper'
require "recursive_open_struct"

describe LsTransactions do
  describe "ls_activity" do
    let!(:user1) { Fabricate( :user, user_name: 'user1', verified_email: true , cashback_id: 'user1') }
    let!(:akccb) { Fabricate( :user, user_name: 'akccb', verified_email: true , cashback_id: 'akccb') }
    let!(:na) { Fabricate( :user, user_name: 'na', verified_email: true , cashback_id: "N/A") }
    let!(:store1) { Fabricate( :store, id_of_store: '38605' ) }
    
    before do
      user1.update_columns( cashback_id: 'user1' )
      akccb.update_columns( cashback_id: 'akccb' )
      na.update_columns( cashback_id: "N/A" )

      responce_csv = File.new("#{Rails.root}/spec/support/test_files/valid_ls.csv")
      LsTransactions.stub(:open).and_return( responce_csv.read )
    end
    
    context "valid records found first time" do  

      it "adds records to Activity" do
        LsTransactions.ls_activity
        expect(Activity.count).to eq(3)
      end
    end

    context "valid update columns" do
      before do
        activty1 = Fabricate( :activity, user_id: user1.id, store_id: store1.id,updated_at: Time.now - 2.days )
        activty2 = Fabricate( :activity, user_id: na.id, store_id: store1.id, updated_at: Time.now - 2.days )
        LsTransactions.ls_activity
      end

      it "updates click column" do
        expect(Activity.find(1).clicks).to eq(12)
      end
      it "updates sales_cents" do
        expect(Activity.find(1).sales_cents).to eq(1200)
      end
      it "updates commission_cents" do
        expect(Activity.find(1).commission_cents).to eq(120)
      end

      it "updates N/A click column" do
        expect(Activity.find(2).clicks).to eq(47)
      end
      it "updates N/A sales_cents" do
        expect(Activity.find(2).sales_cents).to eq(29553)
      end
      it "updates N/A commission_cents" do
        expect(Activity.find(2).commission_cents).to eq(1254)
      end
    end

    context "doesn't update on same day" do
      before do
        activty1 = Fabricate( :activity, user_id: user1.id, clicks: 3, store_id: store1.id, updated_at: Time.now - 2.hours )
        activty2 = Fabricate( :activity, user_id: na.id, store_id: store1.id, sales_cents: 100, updated_at: Time.now - 2.hours )
        LsTransactions.ls_activity
      end

      it "doesn't update clicks" do
        expect(Activity.find(1).clicks).to eq(3)
      end
      it "doesn't update sales" do
        expect(Activity.find(2).sales_cents).to eq(100)
      end
    end

    context "invalid update" do
      before do
        responce_csv = File.new("#{Rails.root}/spec/support/test_files/invalid_ls.csv")
        LsTransactions.stub(:open).and_return( responce_csv.read )
        LsTransactions.ls_activity
      end

      it "do not update or create Activity" do
        expect(Activity.count).to eq(0)
      end
    end
  end

  describe "last_update_ls" do
    context "Activity exists" do
      let!(:activity1) { Fabricate(:activity, updated_at: '2014-01-01 01:24:05') }
      let!(:activity2) { Fabricate(:activity, user_id: 2, updated_at: '2013-01-01 01:24:05') }
      before { LsTransactions.last_update_ls }

      it "return data of up_dated" do
        expect(Activity.order("updated_at DESC").first.updated_at.strftime("%Y%m%d")).to eq('20140101')
      end
    end
    context "Activity does not exist" do
      it "returns todays date minus 1 month" do
        time = DateTime.now - 1.month
        expect(LsTransactions.last_update_ls).to eq(time.strftime("%Y%m%d"))
      end
    end
  end

  

  describe "ls_coupon_id" do
    it "should return correct id" do
      expect(LsTransactions.ls_coupon_id("12345","http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&offerid=297133.3217&type=3&subid=0")).to eq("1234533217")
    end
  end

  describe "title_shorten" do
    it "return shorten title" do
      expect(LsTransactions.title_shorten("Get More Easter for Your Money with Great Deals & Free Shipping on Orders at Walmart.com!")).to eq("Great Deals & Free Shipping On Orders At Waltcom")
    end

    it "removes slashes that are either direction" do
      expect(LsTransactions.title_shorten("$34.99 All Chaps Father & Son tie sets reg. $58. 6/4-6/10.")).to eq("Chaps Father & Son Tie Sets")
    end
  end
end