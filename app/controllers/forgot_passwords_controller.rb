class ForgotPasswordsController < ApplicationController

  def new

  end

  def create
    user = User.where(email: params[:email]).first
    if user
      AppMailer.delay.send_forgot_password(user)
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email].blank? ? "Email cannot be blank." : "Email is not in the system."
      redirect_to forgot_password_path
    end
  end

  def confirm

  end
end