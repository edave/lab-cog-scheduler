class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  def index
     @experiments = Experiment.where(:user_id => current_user.id)
     page_title("Your Dashboard")
  end
  
  def upcoming
     
  end
  
end
