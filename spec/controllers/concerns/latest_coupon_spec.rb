require 'spec_helper'

class FakesController < ApplicationController
  include LatestCoupon
end

describe FakesController do
  let!(:cat) { Fabricate(:kohls_category) }
  let!(:type) { Fabricate(:kohls_type) }
  let!(:only) { Fabricate(:kohls_only) }
  (1..3).each do |i|
    let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", code: "CODE#{i}", created_at:  Time.now - i.hour, end_date: Time.now + i.hour, start_date: Time.now - 12.hour ) }
  end
  before do
    (1..3).each do |i|
      eval("coupon#{i}").kohls_categories << cat
      eval("coupon#{i}").kohls_types << type
      eval("coupon#{i}").kohls_onlies << only
    end
  end

  it "returns latest coupon for kohls_category" do
    expect(subject.latest_coupon_date(cat)).to eq(I18n.l(coupon1.created_at, :format => :w3c))
  end

  it "returns latest coupon for kohls_type" do
    expect(subject.latest_coupon_date(type)).to eq(I18n.l(coupon1.created_at, :format => :w3c))
  end

  it "returns latest coupon for kohls_only" do
    expect(subject.latest_coupon_date(only)).to eq(I18n.l(coupon1.created_at, :format => :w3c))
  end
end