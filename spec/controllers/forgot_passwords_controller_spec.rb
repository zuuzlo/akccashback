require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank email" do
      before { post :create, email:'' }
      
      it "should redirect forgot password" do
        expect(response).to redirect_to forgot_password_path
      end
      
      it "should show message that email needs to be vailid registored user" do
        expect(flash[:danger]).to eq('Email cannot be blank.')
      end
    end

    context "with valid email" do
      before  do
        Fabricate(:user, email: "good@example.com")
        post :create, email: "good@example.com"
      end

      it "should redirect to confirm page" do
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "should send email" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['good@example.com'])
      end
    end

    context "with invalid email" do
      before do
        Fabricate(:user, email: "good@example.com")
        post :create, email: "bad@example.com"
      end

      it "should redirect to forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "should show message need to enter valid email." do
        expect(flash[:danger]).to eq('Email is not in the system.')
      end
    end
  end
end
