class StoresController < ApplicationController
  include CouponCodesOffers
  before_filter :require_user, only:[:save_store, :remove_store]

  def index
    @stores = Store.friendly.to_a
    @stores_featured = Store.with_coupons.limit(12)

    @store_array = []
    @stores.each do | store |
      @store_array << store.name
    end
  end

  def show
    @store = Store.friendly.find(params[:id])
    @coupons = Coupon.where(["store_id = :store AND end_date >= :time ", { :store => @store.id, :time => DateTime.current }]).order( 'end_date ASC' )

    @codes_count = coupon_codes(@coupons)
    @offers_count = coupon_offers(@coupons)
  end

  def save_store
    @store = Store.find_by_id(params[:store_id])
    current_user.stores << @store
    flash[:success] = "#{@store.name} has been added to your favorites."
    respond_to do |format|
      format.html do  
        redirect_to :back
      end
      format.js
    end
  end

  def remove_store
    @store = Store.find_by_id(params[:store_id])
    current_user.stores.delete(@store)
    flash[:success] = "#{@store.name} has been removed from your favorites."
    respond_to do |format|
      format.html do  
        redirect_to :back
      end
      format.js
    end
  end
end
