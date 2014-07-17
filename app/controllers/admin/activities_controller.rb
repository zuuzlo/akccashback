class Admin::ActivitiesController < AdminController

  def index
    @activity_count = Activity.count
    @activities = Activity.all

  end

  def get_activities
    before_count = Activity.count
    LsTransactions.ls_activity
    after_count = Activity.count

    if after_count > before_count
      flash[:success] = "New Activity"
    else
      flash[:danger] = "No new Activity."
    end

    redirect_to admin_activities_path
  end

end