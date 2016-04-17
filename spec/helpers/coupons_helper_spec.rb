require 'spec_helper'


describe CouponsHelper do
  let(:user1) { Fabricate(:user, cashback_id: "1234") }
  let(:store1) { Fabricate(:store)}
  let(:coupon1) { Fabricate(:coupon, store_id: store1.id, code: nil, image: nil ) }
  let(:coupon2) { Fabricate(:coupon, store_id: store1.id, code: 'BIGSALE') }
  let(:kohls_category1) { Fabricate(:kohls_category, name: "cat" ) }
  let(:kohls_only1) { Fabricate(:kohls_only, name: "only") }
  let(:kohls_type1) { Fabricate(:kohls_type, name: "type") }

  describe "#button_link" do
    before do
      helper.extend Haml
      helper.extend Haml::Helpers 
      helper.send :init_haml_helpers
    end

    it "returns correct button link" do
      expect(helper.button_link(coupon1)).to eq("<a class=\"btn btn-primary link_button\" href=\"http://test.host/coupons/1/coupon_link\" rel=\"nofollow\" target=\"_blank\">Shop Now\n<span class='glyphicon glyphicon-chevron-right'></span>\n</a>")
    end      
  end

  describe "#time_left_display" do
    before do
      helper.extend Haml
      helper.extend Haml::Helpers 
      helper.send :init_haml_helpers
    end

    context "less than a day" do
      it "returns danger label" do
        coupon1.update_attribute(:end_date, DateTime.now + 5.hours)
        expect(helper.time_left_display(coupon1)).to eq( "<span class='label label-danger'>\n  <span class='glyphicon glyphicon-time'></span>\n  Expires in about 5 hours\n</span>\n" )
      end
    end
    context "less than three days" do
      it "returns warning label and 2 days" do
        coupon1.update_attribute(:end_date, DateTime.now + 2.days)
        expect(helper.time_left_display(coupon1)).to eq( "<span class='label label-warning'>\n  <span class='glyphicon glyphicon-time'></span>\n  Expires in 2 days\n</span>\n" )
      end
    end
    context "greater that 3 days" do
      it "returns success label and 2 days" do
        coupon1.update_attribute(:end_date, DateTime.now + 5.days)
        expect(helper.time_left_display(coupon1)).to eq( "<span class='label label-success'>\n  <span class='glyphicon glyphicon-time'></span>\n  Expires in 5 days\n</span>\n" )
      end
    end
  end

  describe "#coupon_type" do
    it "returns 'coupon_code' if coupon has code" do
      expect(helper.coupon_type(coupon2)).to eq( "coupon_codes" )
    end

    it "returns 'offers' if no code" do
      expect(helper.coupon_type(coupon1)).to eq( "offers" )
    end
  end

  describe "#favorites" do
    before do
      helper.extend Haml
      helper.extend Haml::Helpers 
      helper.send :init_haml_helpers
      set_current_user(user1)
    end
    context "is a favorite" do
      it "returns correct link and icon" do
        current_user.coupons << coupon1
        expect(helper.favorites("user",coupon1)).to eq( "<a class=\"btn btn-default btn-xs fav_toggle\" data-method=\"post\" data-placement=\"left\" data-remote=\"true\" data-toggle=\"tooltip\" href=\"/coupons/1/toggle_favorite?coupon_id=1\" id=\"toggle_favorite_1\" rel=\"nofollow\" title=\"remove from favorites\"><span class='glyphicon glyphicon-heart'></span>\n</a>" )
      end
    end

    context "is not a favorite" do
      it "returns correct link and icon" do
        expect(helper.favorites("user",coupon1)).to eq( "<a class=\"btn btn-default btn-xs fav_toggle\" container=\"body\" data-method=\"post\" data-placement=\"left\" data-remote=\"true\" data-toggle=\"tooltip\" href=\"/coupons/1/toggle_favorite?coupon_id=1\" id=\"toggle_favorite_1\" rel=\"nofollow\" title=\"add to favorites\"><span class='glyphicon glyphicon-heart-empty'></span>\n</a>" )
      end
    end
  end

  describe "#product_image" do
    it "returns coupon image, coupon has image" do
      coupon2.update(title: "Unde earum perspiciatis non hic.")
      expect(helper.product_image(coupon2)).to eq ("<img alt=\"Unde earum perspiciatis non hic.\" class=\"img-circle\" height=\"125\" src=\"/uploads/coupon/image/1/1322715.jpeg\" width=\"125\" />")
    end

    it "returns store image, coupon has no image" do
      coupon1.update(title: "Ut quis architecto quia.")
      store1.update(store_img: "http://murphybashirian.name/devin.jpg")
      expect(helper.product_image(coupon1)).to eq ("<img alt=\"Ut quis architecto quia.\" class=\"img-circle\" height=\"125\" src=\"\" width=\"125\" />")
    end
  end

  describe "#email_coupon" do
    before do
      helper.extend Haml
      helper.extend Haml::Helpers 
      helper.send :init_haml_helpers
      set_current_user(user1)
    end

    it "return corrct link" do
      expect(helper.email_coupon(coupon1)).to eq ("<button class=\"btn btn-default btn-xs email_tool_tip\" container=\"body\" data-placement=\"right\" data-target=\"#coupon_modal_1\" data-toggle=\"modal\" id=\"coupon_email_button_1\" name=\"button\" rel=\"tooltip\" title=\"email coupon\" type=\"submit\"><span class='glyphicon glyphicon-envelope'></span>\n</button>")
    end
  end

  describe "#not_released" do
    before do
      helper.extend Haml
      helper.extend Haml::Helpers 
      helper.send :init_haml_helpers
    end

    it "returns info label" do
      coupon1.update_attribute(:start_date, DateTime.now + 2.days)
      expect(helper.not_released(coupon1)).to eq( "<span class='label label-info'>\n  <span class='glyphicon glyphicon-time'></span>\n  Valid in 2 days\n</span>\n" )
    end
  end

  describe "#cache_key_for_coupon" do
  end

  describe "#show_ad?" do
  end

  describe "#category_links" do
    it "doesn't return link for self category page display" 
    # this test is taken care of in the indivial views for the links

    it "returns links for kohls_category, kohls_only, kohls_type" do
      coupon1.kohls_categories << kohls_category1
      coupon1.kohls_types << kohls_type1
      coupon1.kohls_onlies << kohls_only1
      expect(helper.category_links(coupon1)).to eq("<a href=\"http://test.host/kohls_categories/cat\">cat</a>\n<a href=\"http://test.host/kohls_types/type\">type</a>\n<a href=\"http://test.host/kohls_onlies/only\">only</a>\n")
    end
    it "returns nothing if no categories" do
      expect(helper.category_links(coupon1)).to be_nil
    end
  end

  describe "#reveal_code_button" do
    before do
      helper.extend Haml
      helper.extend Haml::Helpers 
      helper.send :init_haml_helpers
    end

    it "returns link to display coupon code" do
      expect(helper.reveal_code_button(coupon1)).to eq("<a class=\"btn btn-default btn-xs\" data-method=\"get\" data-remote=\"true\" href=\"http://test.host/coupons/1/reveal_code_link\" id=\"coupon_reveal_button_1\" rel=\"nofollow\">Reveal Code\n</a>")
    end
  end
end
