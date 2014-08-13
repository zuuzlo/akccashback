class CouponsController < ApplicationController
  include CouponCodesOffers
  
  def index
    @coupons = Coupon.where(["end_date >= :time ", { :time => DateTime.current }]).order( 'end_date ASC' )
    @codes_count = coupon_codes(@coupons)
    @offers_count = coupon_offers(@coupons)

    cals = @coupons.pluck(:id).sample(5)
    @cal_coupons = Coupon.find(cals)
  end

  def search
    @coupons = Coupon.search_by_title(params[:search_term])
    @term = params[:search_term]
    @codes_count = coupon_codes(@coupons)
    @offers_count = coupon_offers(@coupons)
  end

  def toggle_favorite
    @coupon = Coupon.find_by_id(params[:coupon_id])
    @refer_controller =  Rails.application.routes.recognize_path(request.referrer)[:controller]
    if current_user.coupon_ids.include?(@coupon.id)
      current_user.coupons.delete(@coupon)
      flash[:success] = "Coupon has been removed from your favorites."
    else
      current_user.coupons << @coupon
      flash[:success] = "Coupon has been added to your favorites."
    end
    
    respond_to do |format|
      format.html do  
        redirect_to :back
      end
      format.js
    end
  end

  def tab_all
    respond_to do |format|
      format.html do  
        redirect_to :back
      end
      format.js
    end
  end

  def tab_coupon_codes
    respond_to do |format|
      format.html do  
        redirect_to :back
      end
      format.js
    end
  end

  def tab_offers
    respond_to do |format|
      format.html do  
        redirect_to :back
      end
      format.js
    end
  end
end
