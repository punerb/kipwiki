class HomeController < ApplicationController
  
  layout "home_layout"
  
  def index
    @featured_projects = Project.where({:featured => true})[0..2]
    # to be changed, also this limit 3 thing has to be applied
    @local_projects = Project.all[0..2]
  end
  
  def filter
    @projects = Project.all
  end
end
