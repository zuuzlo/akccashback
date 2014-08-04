require 'spec_helper'

describe Admin::ActivitiesController do
  describe "GET get_activities" do
    context "No new activities" do
      before do
        set_admin_user
        LsTransactions.stub(:ls_activity).and_return()
        get :get_activities
      end

      it "sets flash to danger" do
        expect(flash[:danger]).to be_present
      end

      it "redirects to admin activities page" do
        expect(response).to redirect_to admin_activities_path
      end
    end

    context "Has new activities" do
      let!(:user1) { Fabricate( :user, verified_email: true , cashback_id: 'user1') }
      let!(:store1) { Fabricate( :store, id_of_store: '12345' ) }
      
      before do
        user1.update_columns( cashback_id: 'user1' )
        activty1 = Fabricate( :activity, user_id: user1.id, clicks: 3, store_id: store1.id )
        set_admin_user
        responce_csv = File.new("#{Rails.root}/spec/support/test_files/valid_ls.csv")
        LsTransactions.stub(:ls_activity).and_return( responce_csv.read )
        get :get_activities
      end

      it "sets flash to success" do
        expect(flash[:success]).to be_present
      end

      it "redirect to admin page" do
        expect(response).to redirect_to admin_activities_path
      end 
    end
  end
end