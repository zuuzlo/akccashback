require 'spec_helper'

describe KohlsTypesController do

  describe "GET show" do
    let(:type1) { Fabricate(:kohls_type) }
    before do 
      store1 = Fabricate(:store, commission: 10)
      coupon = Array.new
      
      (1..7).each do |i|
        coupon[i] = Fabricate(:coupon,store_id: store1.id, title: "coupon#{i}", code: ( i%2 == 0) ? "COUP#{i}" : nil, start_date: Time.now - i.day, end_date: Time.now + i.day )
        type1.coupons << coupon[i]
      end
      get :show, id: type1.id
    end

    it "sets @ktype" do
      expect(assigns(:ktype)).to eq(type1)
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