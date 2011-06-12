class HomeController < ApplicationController
  def index
    @projects = Project.all
  end
  
  def filter
    @projects = Project.all
  end
end
