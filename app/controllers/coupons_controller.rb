class CouponsController < ApplicationController
  include LoadCoupons
  include CouponCodesOffers
  include LoadSeo

  before_filter :require_user, only:[:toggle_favorite, :email_coupon]

  def index
    @coupons = Coupon.active_coupons.paginate(:page => params[:page]).order( 'end_date ASC' )
    load_coupon_offer_code(@coupons)
    load_cal_picts(@coupons)
    render :index, locals: { title: "Home", meta_keywords: seo_keywords(@coupons, nil), meta_description: seo_description(@coupons, nil ) } 
  end

  def search
    @coupons = Coupon.search_by_title(params[:search_term])
    @term = params[:search_term]
    load_coupon_offer_code(@coupons)
    load_cal_picts(@coupons)
  end

  def toggle_favorite
    @coupon = Coupon.find_by_id(params[:coupon_id])
    @refer_controller =  Rails.application.routes.recognize_path(request.referrer)[:controller]
    @action_name = Rails.application.routes.recognize_path(request.referrer)[:action]
  
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

  def email_coupon
    @coupon = Coupon.find_by_id(params[:coupon_id])
    @user = User.find_by_id(params[:user_id])
    @email = params[:email]
    if @email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/
      AppMailer.delay.email_coupon(@email, @user, @coupon)
      flash[:success] = "You have send the coupon to #{params[:email]}"
    else
      flash[:danger] = "#{params[:email]} is not a valid email!"
    end
    
    respond_to do |format|
      format.html do  
        redirect_to :back
      end
      format.js
    end
  end

  def coupon_link
    if Coupon.exists?(params[:id])
      coupon = Coupon.find_by_id(params[:id])
    else
      coupon = Coupon.last
    end
    
    if logged_in?
      if coupon.coupon_source_id == 1
        link = coupon.link + "&u1=" + current_user.cashback_id
      else
        link = coupon.link + "?sid=" + current_user.cashback_id
      end
    else
      if coupon.coupon_source_id == 1
        link = coupon.link + "&u1=akccb"
      else
        link = coupon.link + "?sid=akccb"
      end
    end

    redirect_to link
  end

  def reveal_code_link
    if Coupon.exists?(params[:id])
      @coupon = Coupon.find_by_id(params[:id])
    else
      @coupon = Coupon.last
    end
 
    respond_to do |format|
      format.html do
      end
      format.js
    end
  end
end