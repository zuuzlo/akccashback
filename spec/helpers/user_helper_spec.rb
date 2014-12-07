require 'spec_helper'

describe UserHelper do
  describe "#nav_link_to" do
    let!(:user1) { Fabricate(:user) }
    before do
      set_current_user(user1) 
      helper.extend Haml
      helper.extend Haml::Helpers 
      helper.send :init_haml_helpers
      render partial: "shared/user_nav_tabs", formats: [:html] 
    end
  
    it "has correct output for nav_link_to active link" do
      allow(view).to receive(:current_page?).with(user_path(current_user)).and_return(true)
      expect(helper.nav_link_to("Favorite", user_path(current_user), "heart")).to eq("<li class=\"active\"><a href=\"/users/#{current_user.user_name}\"><span class='glyphicon glyphicon-heart'></span>\nFavorite\n</a></li>")
    end

    it "has correct output for nav_link_to not active link" do
      allow(view).to receive(:current_page?).with(user_path(current_user)).and_return(false)
      expect(helper.nav_link_to("Favorite", user_path(current_user), "heart")).to eq("<li class=\"\"><a href=\"/users/#{current_user.user_name}\"><span class='glyphicon glyphicon-heart'></span>\nFavorite\n</a></li>")
    end

  end
end