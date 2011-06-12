class HomeController < ApplicationController
  
  layout "home_layout"
  
  def index
    @featured_projects = Project.where({:featured => true})
    # to be changed
    @local_projects = Project.all
  end
  
  def filter
    @projects = Project.all
  end
end
