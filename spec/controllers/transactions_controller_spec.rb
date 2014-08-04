require 'spec_helper'

describe TransactionsController do
  
  describe "POST 'create'" do
    let!(:user1) { Fabricate(:user) }
    let!(:store1) { Fabricate(:store) }
    let!(:activity1) { Fabricate(:activity, user_id: user1.id, store_id: store1.id) }
    
    context "withdrawal is valid" do
      before do
        set_current_user(user1)
        post :create, { "transaction"=>{"description"=>"Withdrawal", "amount_cents"=>0.30}, "commit"=>"Withdraw", "action"=>"create", "controller"=>"transactions", "user_id"=> current_user.id }
      end

      it "creates new transaction" do
        expect(Transaction.all.count).to eq(1)
      end

      it "send email for transaction" do
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

      it "redircts to user account balance page" do
        expect(response).to redirect_to new_user_transaction_path(user1)
      end
    end

    context "balance less then withdrawal" do
      before do
        set_current_user(user1)
        post :create, { "transaction"=>{"description"=>"Withdrawal", "amount_cents"=>5.00}, "commit"=>"Withdraw", "action"=>"create", "controller"=>"transactions", "user_id"=> current_user.id }
      end

      it "not create a transaction" do
        expect(Transaction.all.count).to eq(0)
      end

      it "should render new" do
        expect(response).to render_template :new
      end
    end
    context "withdrawal is zero" do
      before do
        set_current_user(user1)
        post :create, { "transaction"=>{"description"=>"Withdrawal", "amount_cents"=> 0}, "commit"=>"Withdraw", "action"=>"create", "controller"=>"transactions", "user_id"=> current_user.id }
      end

      it "not create a transaction" do
        expect(Transaction.all.count).to eq(0)
      end

      it "should render new" do
        expect(response).to render_template :new
      end
    end

    context "withdrawal is not a number" do
      before do
        set_current_user(user1)
        post :create, { "transaction"=>{"description"=>"Withdrawal", "amount_cents"=> "fddf"}, "commit"=>"Withdraw", "action"=>"create", "controller"=>"transactions", "user_id"=> current_user.id }
      end

      it "not create a transaction" do
        expect(Transaction.all.count).to eq(0)
      end

      it "should render new" do
        expect(response).to render_template :new
      end
    end
  end
  describe "GET 'new'" do

    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "sets @user to User current_user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

    it "sets @transaction to new Transaction" do
      get :new
      expect(assigns(:transaction)).to be_instance_of(Transaction)
    end
  end
end