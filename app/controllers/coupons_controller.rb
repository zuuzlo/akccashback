class CouponsController < ApplicationController
  include LoadCoupons
  include CouponCodesOffers

  def index
    @coupons = Coupon.where(["end_date >= :time ", { :time => DateTime.current }]).order( 'end_date ASC' )
    load_coupon_offer_code(@coupons)
    load_cal_picts(@coupons)
  end

  def search
    @coupons = Coupon.search_by_title(params[:search_term])
    @term = params[:search_term]
    load_coupon_offer_code(@coupons)
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
