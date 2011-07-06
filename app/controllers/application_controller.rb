class ApplicationController < ActionController::Base
  layout 'project_layout'
  protect_from_forgery
  def after_sign_in_path_for(user)
    if user.is_admin == false
      if session[:prevurl] == root_url || session[:prevurl] == home_index_url
         dashboard_path
      else
         session[:prevurl]
      end    
    else 
      admin_home_path
    end
  end   
end  
