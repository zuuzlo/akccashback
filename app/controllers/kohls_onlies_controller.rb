class KohlsOnliesController < ApplicationController
  include LoadCoupons
  include LoadSeo
  
  def show
    @only = KohlsOnly.friendly.find(params[:id])
    load_all_coupons(@only)
    render 'shared/display_coupons', locals: { title: @only, meta_keywords: seo_keywords(@coupons, @only), meta_description: seo_description(@coupons, @only) }
  end
end