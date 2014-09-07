require 'spec_helper'


describe CouponsHelper do
  let(:user1) { Fabricate(:user, cashback_id: "1234") }
  let(:store1) { Fabricate(:store)}
  let(:coupon1) { Fabricate(:coupon, store_id: store1.id, code: nil, image: nil ) }
  let(:coupon2) { Fabricate(:coupon, store_id: store1.id, code: 'BIGSALE') }

  describe "#button_link" do
    context "user logged in" do  
      before do
        set_current_user(user1)
        helper.stub(:logged_in?) { true }
      end
      context "source id not 1 no impression pixel" do
        it "returns correct button link" do
          expect(helper.button_link(coupon1)).to eq("<a class=\"btn btn-primary link_button\" data-container=\"body\" data-content=\"Click to get deal at #{coupon1.store.name}.\" data-placement=\"right\" data-toggle=\"popover\" data-trigger=\"hover\" href=\"#{coupon1.link}?sid=#{user1.cashback_id}\" rel=\"nofollow\" target=\"_blank\">Get Deal</a>")
        end      
      end

      context "source id 1 with impression pixel" do
        before do
          coupon1.update_attribute(:coupon_source_id, 1)
          coupon1.update_attribute(:impression_pixel, "http://impression_pixel.com")
        end

        it "returns correct button link with pixel" do
          expect(helper.button_link(coupon1)).to eq("<a class=\"btn btn-primary link_button\" data-container=\"body\" data-content=\"Click to get deal at #{coupon1.store.name}.\" data-placement=\"right\" data-toggle=\"popover\" data-trigger=\"hover\" href=\"#{coupon1.link}&amp;u1=#{user1.cashback_id}\" rel=\"nofollow\" target=\"_blank\"><img alt=\"#{coupon1.title}\" height=\"1\" src=\"http://impression_pixel.com\" width=\"1\" />Get Deal</a>")
        end
      end
    end

    context "not logged in" do
      before do
        helper.stub(:logged_in?) { false }
      end

      context "source id not 1 no impression pixel" do
        it "returns correct button link" do
          expect(helper.button_link(coupon1)).to eq("<a class=\"btn btn-primary link_button\" data-container=\"body\" data-content=\"Click to get deal at #{coupon1.store.name}.\" data-placement=\"right\" data-toggle=\"popover\" data-trigger=\"hover\" href=\"#{coupon1.link}?sid=akccb\" rel=\"nofollow\" target=\"_blank\">Get Deal</a>")
        end      
      end

      context "source id 1 with impression pixel" do
        before do
          coupon1.update_attribute(:coupon_source_id, 1)
          coupon1.update_attribute(:impression_pixel, "http://impression_pixel.com")
        end

        it "returns correct button link with pixel" do
          expect(helper.button_link(coupon1)).to eq("<a class=\"btn btn-primary link_button\" data-container=\"body\" data-content=\"Click to get deal at #{coupon1.store.name}.\" data-placement=\"right\" data-toggle=\"popover\" data-trigger=\"hover\" href=\"#{coupon1.link}&amp;u1=akccb\" rel=\"nofollow\" target=\"_blank\"><img alt=\"#{coupon1.title}\" height=\"1\" src=\"http://impression_pixel.com\" width=\"1\" />Get Deal</a>")
        end
      end
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

  describe "#store_link" do
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
  end

  describe "#product_image" do
    it "returns coupon image, coupon has image" do
      coupon2.update(image: "http://reichertcorwin.org/joshuah.hilll", title: "Unde earum perspiciatis non hic.")
      expect(helper.product_image(coupon2)).to eq ("<img alt=\"Unde earum perspiciatis non hic.\" class=\"img-circle\" height=\"125\" src=\"http://reichertcorwin.org/joshuah.hilll\" width=\"125\" />")
    end

    it "returns store image, coupon has no image" do
      coupon1.update(title: "Ut quis architecto quia.")
      store1.update(store_img: "http://murphybashirian.name/devin.dach")
      expect(helper.product_image(coupon1)).to eq ("<img alt=\"Ut quis architecto quia.\" height=\"125\" src=\"http://murphybashirian.name/devin.dach\" width=\"125\" />")
    end
  end
end
