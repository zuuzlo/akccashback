class Admin::ActivitiesController < AdminController

  def index
    @activity_count = Activity.count
    @activities = Activity.all

  end

  def get_activities
  
    LsTransactions.ls_activity
    
    if Activity.where("updated_at > :now_less_five", { now_less_five: Time.now - 2.minutes }).first
      flash[:success] = "There is New Activity"
    else
      flash[:danger] = "No new Activity."
    end

    redirect_to admin_activities_path
  end

end