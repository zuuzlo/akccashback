class PasswordResetsController < ApplicationController

  def show
    user = User.where(token: params[:id]).first
    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.where(token: params[:token]).first
    if user
      user.password = params[:password]
      user.password_confirmation = params[:password_confirmation]
      user.generate_token
      user.save
      flash[:success] = 'You have successfully changed your password.  Please log in.'
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end
end