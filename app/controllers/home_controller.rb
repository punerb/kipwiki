class HomeController < ApplicationController
  
  layout "home_layout"
  
  def index
    @center_coords = request.location.coordinates.reverse
    
    @featured_projects = Project.where(:featured => true).limit(3)
    @local_projects = Project.near(@center_coords, 50, :units => :km).limit(3)
    @coordinates = @featured_projects.collect {|project| project.coordinates << project.title }
    @coordinates.concat @local_projects.collect {|project| project.coordinates << project.title }
  end
  
  def filter
    @projects = Project.all
  end
end
