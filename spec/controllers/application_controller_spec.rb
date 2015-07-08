require 'spec_helper'

describe ApplicationController do

  describe "current_user helper" do
    let(:user1) { Fabricate(:user) }

    context "no current_user" do
      
      it "returns nil" do
        expect(controller.send(:current_user)).to be_nil
      end
    end

    context "with current_user" do
      it "set current_user to user1" do
        set_current_user(user1)
        expect(controller.send(:current_user)).to eq(user1)
      end
    end
  end

  describe "logged_in? helper" do
    let(:user1) { Fabricate(:user) }

    context "no current_user" do
      
      it "returns false" do
        expect(controller.send(:logged_in?)).to be_false
      end
    end

    context "with current_user" do

      it "returns true" do
        set_current_user(user1)
        expect(controller.send(:logged_in?)).to be_true
      end
    end
  end
  

  describe "display_ad? helper" do
    let(:user1) { Fabricate(:user) }
    context "develoment" do
      
      before { Rails.env.stub(:develoment? => true) }
      
      it "false if no user logged in" do
        expect(controller.send(:display_ad?)).to be_false
      end

      it "false with user" do
        set_current_user(user1)
        expect(controller.send(:display_ad?)).to be_false
      end
    end

    context "production" do
      before { Rails.env.stub(:develoment? => false) }
      it "true if no user" do
        expect(controller.send(:display_ad?)).to be_true
      end

      it "false with user" do
        set_current_user(user1)
        expect(controller.send(:display_ad?)).to be_false
      end
    end
  end
end