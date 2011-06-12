class HomeController < ApplicationController
  
  layout "home_layout"
  
  def index
    @projects = Project.all
  end
  
  def filter
    @projects = Project.all
  end
end
