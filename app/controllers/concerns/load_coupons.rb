module LoadCoupons
  extend ActiveSupport::Concern
  include CouponCodesOffers

  def load(title)
    @coupons = title.coupons.where(["end_date >= :time ", { :time => DateTime.current }]).order( 'end_date ASC' )
    
    @codes_count = coupon_codes(@coupons)
    @offers_count = coupon_offers(@coupons)

    cals = @coupons.pluck(:id).sample(5)
    @cal_coupons = Coupon.find(cals)
  end
end