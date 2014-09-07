class UsersController < ApplicationController
  include CouponCodesOffers
  before_filter :require_user, only:[:show, :edit, :update]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      AppMailer.delay.notify_on_registor(@user)
      flash[:success] = "Welcome to All Kohls Coupons Cash Back!"
      redirect_to sign_in_path
    else
      flash[:danger] = "Please correct the below errors!"
      render 'new'
    end
  end

  def show
    @user = current_user
  
    @coupons = @user.coupons
    @codes_count = coupon_codes(@coupons)
    @offers_count = coupon_offers(@coupons)

    cals = @coupons.pluck(:id).sample(5)
    @cal_coupons = Coupon.find(cals)
  end

  def register_confirmation
    @user = User.where(token: params[:token]).first
    
    if @user
      @user.update( verified_email: TRUE )
      flash[:success] = "You have successfully confirmed your email."
      redirect_to sign_in_path
    else
      flash[:danger] = "Your token has expired!"
      redirect_to expired_token_path
    end
  end

  def edit
    @user = current_user
    if params[:id] == current_user.friendly_id
      render :edit
    else
      flash[:danger] = "You can't edit someone elses profile!"
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = current_user
    #require 'pry'; binding.pry
    if params[:id] == current_user.friendly_id
      if @user.update(user_params)
        flash[:success] = "Profile updated."
      end
      render :edit
    else
      flash[:danger] = "You can't edit someone elses profile!"
      redirect_to edit_user_path(current_user)
    end

    
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :full_name, :terms, :user_name, :paypal_email)
  end
end
