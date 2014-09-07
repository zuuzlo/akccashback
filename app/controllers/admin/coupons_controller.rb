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

  def update
    @coupon = Coupon.find(params[:id])
    if params[:term] == ""
      
      if @coupon.update(coupon_params)
        flash[:success] = "Coupon updated."
        redirect_to admin_coupons_path
      else
        render 'index'
      end
    else
      @new_image = KohlsTransactions.find_product_image(params[:term])
      flash[:success] = "See image below, cut and past url to update coupon image."
      render 'new'
    end
  end

  def destroy
    Coupon.find(params[:id]).destroy
    flash[:success] = "You have removed a coupon."
    redirect_to admin_coupons_path
  end

  def index
    @coupon_count = Coupon.count
    @coupons = Coupon.order('end_date ASC').load
  end

  def get_kohls_coupons
    count_start = Coupon.count 
    KohlsTransactions.kohls_update_coupons
    count_finish = Coupon.count
    
    if count_finish > count_start
      flash[:success] = "Kohls Coupons are updated, you imported #{count_finish - count_start} coupons."
    else
      flash[:danger] = "No new coupons were imported"
    end

    redirect_to admin_coupons_path
  end

  def delete_kohls_coupons
    delete_coupons = []
    Coupon.all.each do | coupon |
      delete_coupons << coupon.id if coupon.end_date < Time.now
    end
    Coupon.delete(delete_coupons)
    flash[:success] = "Deleted #{delete_coupons.count} coupons."
    redirect_to admin_coupons_path
  end

  private

  def coupon_params
    params.require(:coupon).permit(:id, :id_of_coupon, :title, :description, :start_date, :end_date, :code, :restriction, :link, :impression_pixel, :image, :store_id, :coupon_source_id )
  end
end