class ApplicationController < ActionController::Base

  layout 'project_layout'
  protect_from_forgery
  def after_sign_in_path_for(user)
    if user.is_admin == false
      dashboard_path
    else 
      admin_home_path
    end
  end   
end  
