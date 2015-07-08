require 'spec_helper'

describe ApplicationController do

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