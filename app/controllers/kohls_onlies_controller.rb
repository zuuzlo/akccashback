class KohlsOnliesController < ApplicationController
 include LoadCoupons
  
  def show
    @only = KohlsOnly.friendly.find(params[:id])
    load_all_coupons(@only)
    render 'shared/display_coupons', locals: { title: @only }
  end
end