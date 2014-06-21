class AdminController < ApplicationController
  helper_method :ensure_admin, :admin?
  before_filter :ensure_admin

  def ensure_admin
    if !current_user.admin?
      flash[:danger] = 'You don not have access to area.'
      redirect_to user_path(current_user)
    end
  end

  def admin?
    current_user.admin
  end
end