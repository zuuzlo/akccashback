require 'spec_helper'

describe CategoriesController do

  describe "GET show" do
    let(:cat1) { Fabricate(:category) }
    before { get :show, id: cat1.id }

    it "sets @category" do
      expect(assigns(:category)).to eq(cat1)
    end

    it "renders template display_coupons" do
      expect(response).to render_template 'shared/display_coupons'
    end
  end
end