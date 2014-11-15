require 'spec_helper'

describe KohlsOnliesController do

  describe "GET show" do
    let(:only1) { Fabricate(:kohls_only) }
    before do 
      store1 = Fabricate(:store, commission: 10)
      coupon = Array.new
      
      (1..7).each do |i|
        coupon[i] = Fabricate(:coupon,store_id: store1.id, title: "coupon#{i}", code: ( i%2 == 0) ? "COUP#{i}" : nil, start_date: Time.now - i.day, end_date: Time.now + i.day )
        only1.coupons << coupon[i]
      end
      get :show, id: only1.id
    end

    it "sets @only" do
      expect(assigns(:only)).to eq(only1)
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
  end
end