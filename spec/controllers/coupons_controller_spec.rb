require 'spec_helper'

describe CouponsController do
  describe "GET search" do
    let!(:coupon1) { coupon1 = Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 1.hour ) }
    let!(:coupon2) { coupon2 = Fabricate(:coupon, code: nil, description: 'fast car', end_date: Time.now + 1.hour ) }
    let!(:coupon3) { coupon3 = Fabricate(:coupon, code: nil, description: 'fast dog', end_date: Time.now + 1.hour ) }
    before { get :search, search_term: 'car' }

    it "set @coupons where coupons description has search term" do   
      expect(assigns(:coupons)).to eq([coupon1, coupon2])
    end

    it "set @term to search term" do     
      expect(assigns(:term)).to eq('car')
    end

    it "set @codes_count" do      
      expect(assigns(:codes_count)).to eq(1)
    end

    it "set @offers_count" do   
      expect(assigns(:offers_count)).to eq(1)
    end
  end

  describe "POST toggle_favorite" do
    let!(:store1) { Fabricate(:store) }
    let!(:coupon1) { coupon1 = Fabricate(:coupon, store_id: store1.id) }
    context "with authenticated user" do
      before do
        set_current_user
        request.env["HTTP_REFERER"] = store_path(store1) 
      end
      after { current_user.coupons.clear }

      it "sets @coupon" do
        post :toggle_favorite, { id: coupon1.id, coupon_id: coupon1.id }
        expect(assigns(:coupon)).to eq(coupon1)
      end

      context "coupon not in favorites" do
        before do
          post :toggle_favorite, { id: coupon1.id, coupon_id: coupon1.id }
        end

        it "adds coupon to users coupons (favorite)" do
          expect(current_user.coupons.count).to eq(1)
        end

        it "set flash success" do
          expect(flash[:success]).to be_present
        end
      end
      
      context "coupon in favorites" do
        before do
          current_user.coupons << coupon1
          post :toggle_favorite, { id: coupon1.id, coupon_id: coupon1.id }
        end

        it "removes coupon from users" do
          expect(current_user.coupons.count).to eq(0)
        end

        it "set flash success" do
          expect(flash[:success]).to be_present
        end
      end
    end
  end
  describe "GET index" do
    let!(:coupon1) { coupon1 = Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 3.hour ) }
    let!(:coupon2) { coupon2 = Fabricate(:coupon, code: nil, description: 'fast car', end_date: Time.now + 1.hour ) }
    let!(:coupon3) { coupon3 = Fabricate(:coupon, code: nil, description: 'fast dog', end_date: Time.now + 2.hour ) }

    before { get :index }

    it "load coupons in order" do
      expect(assigns(:coupons)).to eq([coupon2, coupon3, coupon1])
    end

    it "have 1 @codes_count" do
      expect(assigns(:codes_count)).to eq(1)
    end

    it "have 2 @offers_count" do
      expect(assigns(:offers_count)).to eq(2)
    end

    it "have 3 @cal_coupons" do
      expect(assigns(:cal_coupons).count).to eq(3)
    end
  end

  describe "POST email_coupon" do
    let!(:coupon1) { Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 1.days ) }
    
    before do
      
      request.env["HTTP_REFERER"] = coupons_path
      #post :email_coupon, { coupon_id: coupon1.id, email: "test@test.com", id: current_user.id }
    end

    context "valid email address by current user" do
      before do
        set_current_user
        post :email_coupon, { coupon_id: coupon1.id, email: "test@test.com", id: coupon1.id, user_id: current_user.id }
      end

      it "gets right coupon" do
        expect(assigns(:coupon)).to eq(coupon1)
      end

      it "assigns current_user to user" do
        expect(assigns(:user)).to eq(current_user)
      end 

      it "sends email" do
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "email to righ recipient" do
        message = ActionMailer::Base.deliveries.last
        message.to.should == ["test@test.com"]
      end

      it "email has right content" do
        message = ActionMailer::Base.deliveries.last
        message.body.should include(User.find(1).email)
      end

      it "sets flash success" do
        expect(flash[:success]).to be_present
      end
    end

    context "not valid email by current user" do
      before do
        set_current_user
        post :email_coupon, { coupon_id: coupon1.id, email: "test@test", id: coupon1.id, user_id: current_user.id }
      end

      it "sets flash danger" do
        expect(flash[:danger]).to be_present
      end
    end

    context "valid email address by not current user" do
      let(:user1) { Fabricate(:user, verified_email: TRUE) }
      it_behaves_like "require_sign_in" do
        let(:action) { post :email_coupon, { coupon_id: coupon1.id, email: "test@test.com", id: coupon1.id, user_id: user1.id }}
      end
    end
  end

  describe "GET coupon_link" do
    let!(:coupon1) { coupon1 = Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 3.hour ) }

    context "no user source id 1" do
      before { get :coupon_link, id: coupon1.id }

      it "should redirect to link of coupon plus added" do
        expect(response).to redirect_to coupon1.link + "&u1=akccb"
      end
    end

    context "user link source id 1" do
      let(:user1) { Fabricate(:user, verified_email: TRUE) }
      before do
        set_current_user(user1)
        get :coupon_link, id: coupon1.id
      end
      it "should redirect to link of coupon plus added" do
        expect(response).to redirect_to coupon1.link + "&u1=#{user1.cashback_id}"
      end
    end
  end
end
