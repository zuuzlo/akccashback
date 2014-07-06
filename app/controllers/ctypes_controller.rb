class CtypesController < ApplicationController
  include CouponCodesOffers
  def show
    @ctype = Ctype.friendly.find(params[:id])
    @coupons = @ctype.coupons.where(["end_date >= :time ", { :time => DateTime.current }]).order( 'end_date ASC' )

    @codes_count = coupon_codes(@coupons)
    @offers_count = coupon_offers(@coupons)

    cals = @coupons.pluck(:id).sample(3)
    @cal_coupons = Coupon.find(cals)
  end
end