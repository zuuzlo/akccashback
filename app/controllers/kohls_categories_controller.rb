class KohlsCategoriesController < ApplicationController
  
  include LoadCoupons

  def show
    @category = KohlsCategory.friendly.find(params[:id])
    load(@category)
    render 'shared/display_coupons', locals: { title: @category}
  end
end