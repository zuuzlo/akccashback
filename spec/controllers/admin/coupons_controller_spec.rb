require 'spec_helper'

describe Admin::CouponsController do
  describe "GET new" do
    before { set_admin_user }
    it "sets @coupon to coupon new" do
      get :new
      expect(assigns(:coupon)).to be_instance_of(Coupon)
    end
  end

  describe "POST create" do
    context "for admin user" do
      before { set_admin_user }

      context "with valid input" do
        let(:coupon) { Fabricate.attributes_for(:coupon) }
        before { post :create, coupon: coupon }
        
        it "redirects to add coupon page" do
          expect(response).to redirect_to new_admin_coupon_path
        end

        it "creates a coupon" do
          expect(Coupon.count).to eq(1)
        end

        it "displays a success message that a new coupon was created" do
          expect(flash[:success]).to be_present
        end
      end

      context "with invalid input" do
        let(:coupon) { Fabricate.attributes_for(:coupon, title: '') }
        before { post :create, coupon: coupon }

        it "redirects to add coupon page" do
          expect(response).to render_template 'new'
        end

        it "doesn't create a video" do
          expect(Coupon.count).to eq(0)
        end

        it "sets the flash danger" do
          expect(flash[:danger]).to be_present
        end
      end
    end

    context "for non admin user" do

      let(:coupon) { Fabricate.attributes_for(:coupon) }
      before do
        set_current_user
        post :create, coupon: coupon
      end

      it "does not create a coupon" do
        expect(Coupon.count).to eq(0)
      end
      it "redirects to user home page" do
        expect(response).to redirect_to user_path(current_user)
      end
      it "sets the flash danger" do
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "GET index" do
    context "for admin user" do
      before { set_admin_user }

      it "@coupon has 3 coupons" do
        (1..3).each do |i|
          coupon[i] = Fabricate(:coupon, title: "coupon#{i}", end_date: Time.now + i.hour )
        end

        get :index
        expect(assigns(:coupons).count).to be(3)
      end
    end
  end
end