require 'spec_helper'

describe ActivitiesController do

  describe "GET 'index'" do
    context "valid user current" do
      let!(:user1) { Fabricate(:user, verified_email: TRUE) }
      let!(:store1) { Fabricate(:store) }
      let!(:activity1) { Fabricate(:activity, user_id: user1.id, store_id: store1.id )}
      
      before do
        set_current_user(user1)
        get :index, { user_id: user1.id }
      end
      
      it "returns http success" do
        response.should be_success
      end

      it "sets @user to current_user" do
        expect(assigns(:user)).to eq(current_user)
      end

      it "sets @activity to users and store activity" do
        expect(assigns(:activity)).to eq(activity1)
      end
    end

    context "not current user" do
      let!(:user1) { Fabricate(:user, verified_email: TRUE) }
      let!(:store1) { Fabricate(:store) }
      let!(:activity1) { Fabricate(:activity, user_id: user1.id, store_id: store1.id )}
      let!(:user2) { Fabricate(:user, verified_email: TRUE) }
      before do
        set_current_user(user2)
      end

      it_behaves_like "require_sign_in" do
        let(:action) { get :index, { user_id: user1.id } }
      end
    end
  end
end
