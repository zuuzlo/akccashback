require 'spec_helper'

describe KohlsCategoriesController do

  describe "GET show" do
    let(:cat1) { Fabricate(:kohls_category) }
    before do 
      store1 = Fabricate(:store, commission: 10)
      coupon = Array.new
      
      (1..7).each do |i|
        coupon[i] = Fabricate(:coupon,store_id: store1.id, title: "coupon#{i}", code: ( i%2 == 0) ? "COUP#{i}" : nil, start_date: Time.now - i.day, end_date: Time.now + i.day )
        cat1.coupons << coupon[i]
      end

      get :show, id: cat1.id
    end
  
    it "sets @category" do
      expect(assigns(:category)).to eq(cat1)
    end

    it "sets @coupons" do
      expect(assigns(:coupons).count).to eq(7)
    end

    it "sets @cal_coupons" do
      expect(assigns(:cal_coupons).count).to eq(5)
    end

    it "renders template display_coupons" do
      expect(response).to render_template 'shared/display_coupons'
    end

    it "set @description string" do
      expect(assigns(:description).length).to eq(160)
    end
  end
end