require 'spec_helper'

describe KohlsOnliesController do

  describe "GET show" do
    let(:only1) { Fabricate(:kohls_only) }
    before { get :show, id: only1.id }

    it "sets @only" do
      expect(assigns(:only)).to eq(only1)
    end

    it "renders template display_coupons" do
      expect(response).to render_template 'shared/display_coupons'
    end
  end
end