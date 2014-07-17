require 'spec_helper'


describe CouponsHelper do
  let(:user1) { Fabricate(:user, cashback_id: "1234") }
  let(:store1) { Fabricate(:store)}
  let(:coupon1) { Fabricate(:coupon, store_id: store1.id) }

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
          expect(helper.button_link(coupon1)).to eq("<a class=\"btn btn-primary link_button\" data-container=\"body\" data-content=\"Click to get deal at #{coupon1.store.name}.\" data-placement=\"right\" data-toggle=\"popover\" data-trigger=\"hover\" href=\"#{coupon1.link}?sid=zuuzlo\" rel=\"nofollow\" target=\"_blank\">Get Deal</a>")
        end      
      end

      context "source id 1 with impression pixel" do
        before do
          coupon1.update_attribute(:coupon_source_id, 1)
          coupon1.update_attribute(:impression_pixel, "http://impression_pixel.com")
        end

        it "returns correct button link with pixel" do
          expect(helper.button_link(coupon1)).to eq("<a class=\"btn btn-primary link_button\" data-container=\"body\" data-content=\"Click to get deal at #{coupon1.store.name}.\" data-placement=\"right\" data-toggle=\"popover\" data-trigger=\"hover\" href=\"#{coupon1.link}&amp;u1=zuuzlo\" rel=\"nofollow\" target=\"_blank\"><img alt=\"#{coupon1.title}\" height=\"1\" src=\"http://impression_pixel.com\" width=\"1\" />Get Deal</a>")
        end
      end
    end
  end

  describe "#time_left_display" do
  end

  describe "#store_link" do
  end

  describe "#coupon_type" do
  end

  describe "#favorites" do
  end

  describe "product_image" do
  end
end
