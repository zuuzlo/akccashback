class CategoriesController < ApplicationController
  include CouponCodesOffers
  def show
    @category = Category.friendly.find(params[:id])
    @coupons = @category.coupons.where(["end_date >= :time ", { :time => DateTime.current }]).order( 'end_date ASC' )
    
    @codes_count = coupon_codes(@coupons)
    @offers_count = coupon_offers(@coupons)
  end
end