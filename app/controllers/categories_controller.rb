class CategoriesController < ApplicationController
  include LoadCoupons
  
  def show
    @category = Category.friendly.find(params[:id])
    load(@category)
    render template: 'shared/display_coupons', locals: { title: @category}
  end
end