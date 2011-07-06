class HomeController < ApplicationController
  
  layout "home_layout"
  
  def index
    @shown_projects = Project.where(:is_hidden => false)
    @center_coords = request.location.coordinates
    @featured_projects = @shown_projects.where(:featured => true).limit(3)
    @local_projects = Project.near(@center_coords.reverse, 50, :units => :km).limit(3)
    @coordinates = @featured_projects.collect {|project| project.coordinates << project.title }
    @coordinates.concat @local_projects.collect {|project| project.coordinates << project.title }
  end
  
  def filter
    @projects = Project.all
  end
end
