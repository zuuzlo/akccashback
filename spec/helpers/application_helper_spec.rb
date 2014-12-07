require 'spec_helper'

describe ApplicationHelper do
  describe "#user_home?" do
    let(:user1) { Fabricate(:user) }
    let(:user2) { Fabricate(:user) }
    context "current user" do
      before do
        set_current_user(user1)
      end

      it "returns true if on user home page for params[:id]" do
        params[:id] = user1.slug
        expect(helper.user_home?).to be_true
      end

      it "returns true if on user home page for params[:user_id]" do
        params[:user_id] = user1.slug
        expect(helper.user_home?).to be_true
      end
    end

    context "not current user" do
      before do
        set_current_user(user2)
      end

      it "returns false not on user home page for params[:id]" do
        params[:id] = user1.slug
        expect(helper.user_home?).to be_false
      end

      it "returns false if not on user home page for params[:user_id]" do
        params[:user_id] = user1.slug
        expect(helper.user_home?).to be_false
      end
    end
  end

  describe "#filt_page?" do
    context "returns true" do
      it "if one of pages returns true" do
        params[:controller] = 'kohls_categories'
        expect(helper.filt_page?).to be_true
      end

      it "if one of pages returns true" do
        params[:controller] = 'kohls_types'
        expect(helper.filt_page?).to be_true
      end

      it "if one of pages returns true" do
        params[:controller] = 'kohls_onlies'
        expect(helper.filt_page?).to be_true
      end
    end

    context "returns false" do
      it "if one of pages returns false" do
        params[:controller] = 'users'
        expect(helper.filt_page?).to be_false
      end
    end
  end

  describe "#full_title" do
    context "page title empty" do
      it "returns base title" do
        expect(helper.full_title("")).to eq("Cash Back at Kohls: 30% Promo Codes, Kohls Coupon Codes")
      end
    end

    context "page title has a value" do
      it "returns base title" do
        expect(helper.full_title("Baby")).to eq("Cash Back at Kohls: 30% Promo Codes, Kohls Coupon Codes | Baby Coupons and Deals")
      end
    end
  end


end