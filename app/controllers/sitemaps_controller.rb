class SitemapsController < ApplicationController
  include LatestCoupon
  
  def index
    static_urls = [ { url: '/landing', updated_at: "" } ]
    @pages_to_visit = static_urls
    @pages_to_visit += KohlsCategory.with_coupons.collect{ |a| { url: kohls_category_path(a.slug) ,  updated_at: latest_coupon_date(a), changefreq: 'daily', priority: '0.9' } }
    @pages_to_visit += KohlsType.with_coupons.collect{ |b| { url: kohls_type_path(b.slug) ,  updated_at: latest_coupon_date(b), changefreq: 'daily', priority: '0.9' } }
    @pages_to_visit += KohlsOnly.with_coupons.collect{ |c| { url: kohls_only_path(c.slug) ,  updated_at: latest_coupon_date(c), changefreq: 'daily', priority: '0.9' } }

    respond_to do |format|
      format.xml
    end
  end
end