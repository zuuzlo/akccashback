class ActivitiesController < ApplicationController
  
  before_filter :require_user, only:[:index]
  
  def index
    @user = current_user
    @activity = Activity.find_by_user_id(current_user.id)
  end
end
