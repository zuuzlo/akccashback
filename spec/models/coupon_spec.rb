require 'spec_helper'

describe Coupon do
  it { should belong_to(:store) }
  it { should have_and_belong_to_many(:categories) }
  it { should have_and_belong_to_many(:kohls_categories) }
  it { should have_and_belong_to_many(:kohls_onlies) }
  it { should have_and_belong_to_many(:ctypes) }
  it { should validate_presence_of(:id_of_coupon) }
  it { should validate_uniqueness_of(:id_of_coupon) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:link) }

  let(:store1)  { Fabricate(:store, name: 'store1', commission: 4 )}
  let(:coupon1) { Fabricate(:coupon, title: "coupon1", description: 'this is a good coupon', end_date: Time.now + 1.day, store_id: store1.id ) }
  
  describe "time_left" do
    it "returns time left until expires in words" do
      expect(coupon1.time_left).to eq("1 day")
    end
  end

  describe "store_name" do
    it "returns name of coupons store" do
      expect(coupon1.store_name).to eq("store1")
    end
  end
  
  describe "store_image" do
    it "returns store image of coupon store" do
      expect(coupon1.store_image).to eq(store1.store_img)
    end
  end

  describe "store_commission" do
    it "returns store commission divided by 2" do
      expect(coupon1.store_commission).to eq(2)
    end
  end

  describe "search_by_title" do
    it "returns nothing if search term is blank" do
      search = Coupon.search_by_title('jump')
      expect(search.size).to eq 0
    end

    it "returns one if one coupon description has search term" do
      coupon1 = Fabricate(:coupon, title: "coupon1", description: 'this is a good coupon', end_date: Time.now + 1.day, store_id: store1.id ) 
      search = Coupon.search_by_title('good')
      expect(search.size).to eq 1
    end

    it "returns many if many coupons description has search term" do
      coupon = []
      (1..3).each do |i|
        coupon[i] = Fabricate(:coupon, title: "coupon#{i}", description: "this is a good coupon#{i}", end_date: Time.now + i.day, store_id: store1.id )  
      end
      search = Coupon.search_by_title('good')
      expect(search.size).to eq 3
    end
  end
  describe 'nil_if_blank on code' do

      let(:store1) { Fabricate(:store, name: 'store1', commission: 4 ) }
      let(:coupon1) { Fabricate(:coupon, title: "coupon1", description: 'this is a good coupon', end_date: Time.now + 1.day, store_id: store1.id ) }

    it "should not save code as a blank" do
      coupon1.update(code: '')
      expect(coupon1.code).to be_nil
    end

    it "should not save restriction as a blank" do
      coupon1.update(restriction:'')
      expect(coupon1.restriction).to be_nil
    end
  end

  describe "#preview?" do
    it "returns true if the start_date is greater than now" do
      coupon1 = Fabricate(:coupon, title: "coupon1", description: 'this is a good coupon', start_date: Time.now + 1.day, end_date: Time.now + 2.day, store_id: store1.id )
      expect(coupon1.preview?).to be_true
    end

    it "returns false if the start_date is less than now" do
      coupon1 = Fabricate(:coupon, title: "coupon1", description: 'this is a good coupon', start_date: Time.now - 1.day, end_date: Time.now + 2.day, store_id: store1.id )
      expect(coupon1.preview?).to be_false
    end
  end

  describe "#time_til_good" do
    it "returns time left until coupon is valid in words" do
      coupon1 = Fabricate(:coupon, title: "coupon1", description: 'this is a good coupon', start_date: Time.now + 1.day, end_date: Time.now + 2.day, store_id: store1.id )
      expect(coupon1.time_til_good).to eq("1 day")
    end
  end

  describe "#active_coupons" do
  
    (1..3).each do |i|
      let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", end_date: Time.now - i.hour, start_date: Time.now - 12.hour ) }
    end

    (4..5).each do |i|
      let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", end_date: Time.now + i.hour, start_date: Time.now - 12.hour ) }
    end

    it "returns coupons that are valid" do 
      expect(Coupon.active_coupons.size).to eq(2)
    end

    it "returns in correct order" do
      expect(Coupon.active_coupons).to eq([coupon4,coupon5])
    end
  end
end