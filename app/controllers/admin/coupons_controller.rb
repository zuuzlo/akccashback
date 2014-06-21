class Admin::CouponsController < AdminController
  
  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.create(coupon_params)
    if @coupon.save
      flash[:success] = "You have added a new coupon."
      redirect_to new_admin_coupon_path
    else
      flash[:danger] = "Please correct the below errors."
      render 'new'
    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
    render 'new'
  end

  def index
    @coupons = Coupon.all

  end

  def get_kohls_coupons

  end

  private

  def coupon_params
    params.require(:coupon).permit(:id_of_coupon, :title, :description, :start_date, :end_date, :code, :restriction, :link, :impression_pixel, :image, :store_id, :coupon_source_id )
  end
end