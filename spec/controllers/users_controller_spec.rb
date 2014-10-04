require 'spec_helper'

describe UsersController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "sets @user to User new" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST 'create'" do
    context "signup successful" do
      before do
        post :create, user: { email: 'test@test.com', password: 'password', password_confirmation: 'password', user_name: 'test', terms: true }
      end

      it "creates a new @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "should save new user" do
        expect(User.count).to eq(1)
      end

      it "should send an email" do
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "email to right recipient" do
        message = ActionMailer::Base.deliveries.last
        message.to.should == [User.find(1).email]
      end

      it "email has right content" do
        message = ActionMailer::Base.deliveries.last
        message.body.should include(User.find(1).full_name)
      end

      it "the flash success is set" do
        expect(flash[:success]).to be_present
      end

      it "redirects to sign in path" do
        expect(response).to redirect_to page_path('welcome')
      end
    end

    context "signup fails" do
      before do
        post :create, user: { email: 'test@test.com', full_name: 'Test Test', user_name: 'testtest'}
      end

      it "the flash danger is set" do
        expect(flash[:danger]).to be_present
      end

      it "renders new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET 'register_confirmation'" do
    context "users token matches" do
      let(:user1) { Fabricate(:user, email: 'test@test.com', password: 'password', password_confirmation: 'password', full_name: 'Test Test') }
      before do
        get :register_confirmation, token: user1.token
      end
      
      it "finds user from token" do
        expect(assigns(:user).token).to eq(user1.token)
      end

      it "sets verified_token to true" do
        expect(assigns(:user).verified_email).to be_true
      end

      it "sets flash success" do
        expect(flash[:success]).to be_present
      end

      it "redirects to sign in" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "users token doesn't match" do
      let(:user1) { Fabricate(:user, email: 'test@test.com', password: 'password', password_confirmation: 'password', full_name: 'Test Test') }
      before do
        get :register_confirmation, token: '123434'
      end

      it "sets flash danger" do
        expect(flash[:danger]).to be_present
      end

      it "redirects to expired token" do
        expect(response).to redirect_to expired_token_path
      end
    end
  end

  describe "GET 'show'" do
    let(:other_user) { Fabricate(:user, verified_email: TRUE) }
    let(:user1) { Fabricate(:user, verified_email: TRUE) }
    context "with authenticated user" do
      
      before do
        set_current_user(user1)
        store1 = Fabricate(:store, commission: 10)
        coupon = Array.new
        (1..7).each do |i|
          coupon[i] = Fabricate(:coupon,store_id: store1.id, title: "coupon#{i}", code: ( i%2 == 0) ? "COUP#{i}" : nil, start_date: Time.now - i.day, end_date: Time.now + i.day )
          user1.coupons << coupon[i]
        end
      end

      it "load @user for other user not in session" do
        get :show, { id: other_user.id }
        expect(assigns(:user)).to eq(user1)
      end

      it "load @user favorite coupons" do
        get :show, { id: user1.id }
        expect(assigns(:coupons).count).to eq(7)
      end

      it "counts numbers of coupon codes" do
        get :show, { id: user1.id }
        expect(assigns(:codes_count)).to eq(3)
      end

      it "counts numbers of offers" do
        get :show, { id: user1.id }
        expect(assigns(:offers_count)).to eq(4)
      end

      it "has five cal_coupons" do
        get :show, { id: user1.id }
        expect(assigns(:cal_coupons).count).to eq(5)
      end
    end

    context "user email not verified" do
      let(:bad_user) { Fabricate(:user) }
      it "doesn't load @user" do
        get :show,  { id: bad_user.id }
        expect(assigns(:user)).to eq(nil)
      end
    end
  end

  describe "GET edit" do
    context "current user" do
      let(:user1) { Fabricate(:user, verified_email: TRUE) }

      before do
        set_current_user(user1)
        get :edit, id: current_user.friendly_id
      end

      it "gets @user for current user" do
        expect(assigns(:user)).to eq(current_user)
      end

      it "renders edit template" do
        expect(response).to render_template :edit
      end
    end

    context "not current user" do
      let(:user1) { Fabricate(:user, verified_email: TRUE) }
      let(:user2) { Fabricate(:user, verified_email: TRUE) }
      
      before do
        set_current_user(user1)
        get :edit, id: user2.friendly_id
      end

      it "doesn't set @user for other user" do
        expect(assigns(:user)).not_to eq(user2)
      end

      it "sets danger message" do
        expect(flash[:danger]).to be_present
      end

      it "redirects to show user" do
        expect(response).to redirect_to user_path(user1)
      end
    end

    context "not current user" do
      let(:user1) { Fabricate(:user, verified_email: TRUE) }
     
      it_behaves_like "require_sign_in" do
        let(:action) { get :edit, { id: user1.friendly_id } }
      end
    end
  end

  describe "PATCH 'update'" do
    context "current user" do
      let(:user1) { Fabricate(:user, verified_email: TRUE) }
      
      before do
        set_current_user(user1)
        patch :update, id: user1.friendly_id, user: {paypal_email: 'user1@user1.com'}
      end
      
      it "sets @user to current user" do
        expect(assigns(:user)).to eq(user1)
      end
      
      it "updates user profile" do
        expect(assigns(:user).paypal_email).to eq('user1@user1.com')
      end

      it "renders edit" do
        expect(response).to render_template :edit
      end
    end
    context "not current user" do
      let(:user1) { Fabricate(:user, verified_email: TRUE) }
      let(:user2) { Fabricate(:user, verified_email: TRUE) }
      
      before do
        set_current_user(user1)
        patch :update, id: user2.friendly_id, user: { paypal_email: 'user1@user1.com' }
      end

      it "doesn't set @user for other user" do
        expect(assigns(:user)).not_to eq(user2)
      end

      it "sets danger message" do
        expect(flash[:danger]).to be_present
      end

      it "redirects to show user" do
        expect(response).to redirect_to edit_user_path(user1)
      end

      it "it should not updates user profile" do
        expect(assigns(:user).paypal_email).not_to eq('user1@user1.com')
      end
    end

    context "not current user" do
      let(:user1) { Fabricate(:user, verified_email: TRUE) }
     
      it_behaves_like "require_sign_in" do
        let(:action) { patch :update, id: user1.friendly_id, user: { paypal_email: 'user1@user1.com' } }
      end
    end
  end

  describe "GET all_coupons" do
    let(:other_user) { Fabricate(:user, verified_email: TRUE) }
    let(:user1) { Fabricate(:user, verified_email: TRUE) }
    context "with authenticated user" do
      before do
        set_current_user(user1)
        store1 = Fabricate(:store, commission: 10)
        coupon = Array.new
        (1..7).each do |i|
          coupon[i] = Fabricate(:coupon,store_id: store1.id, title: "coupon#{i}", code: ( i%2 == 0) ? "COUP#{i}" : nil, start_date: Time.now - i.day, end_date: Time.now + i.day )
        end
        get :all_coupons, { id: user1.id }
      end

      it "sets @user to current user" do
        expect(assigns(:user)).to eq(user1)
      end

      it "load all coupons coupons" do
        expect(assigns(:coupons).count).to eq(7)
      end

      it "counts numbers of coupon codes" do
        expect(assigns(:codes_count)).to eq(3)
      end

      it "counts numbers of offers" do
        expect(assigns(:offers_count)).to eq(4)
      end

      it "has five cal_coupons" do
        expect(assigns(:cal_coupons).count).to eq(5)
      end
    end

    context "not current user" do

      it_behaves_like "require_sign_in" do
        let(:action) { get :all_coupons, { id: user1.friendly_id } }
      end
    end
  end
end
