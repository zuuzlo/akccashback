class KohlsTypesController < ApplicationController

  include LoadCoupons

  def show
    @ktype = KohlsType.friendly.find(params[:id])
    load(@ktype)
    render 'shared/display_coupons', locals: { title: @ktype}
  end
end