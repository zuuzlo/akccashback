require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    
    let!(:kirk) { Fabricate(:user) }
    before do
      kirk.update_column(:token, '12345')
    end

    it "renders show template if the token is valid" do
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "renders the expired token page if the token is not valid" do
      get :show, id: '1dfadf5'
      expect(response).to redirect_to expired_token_path
    end

    it "sets @token" do
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end
  end
  describe "POST create" do
    context "with valid token" do
      let!(:kirk) { Fabricate(:user, password: 'old_password', password_confirmation: 'old_password') }
      before do
        kirk.update_column(:token, '12345')
        post :create, token:'12345', password:'new_password', password_confirmation: 'new_password'
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "should update users password" do
        expect(kirk.reload.authenticate('new_password')).to be_true
      end

      it "sets the flash success message" do
        expect(flash[:success]).to eq('You have successfully changed your password.  Please log in.')
      end

      it "regenerates the users token" do
        expect(kirk.reload.token).not_to eq('12345')
      end
    end
    context "with invalid token" do

      it"redirects to expired token path" do
        post :create, token: '12345', password: 'some_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
