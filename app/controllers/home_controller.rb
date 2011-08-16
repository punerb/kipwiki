class HomeController < ApplicationController
  
  layout "home_layout"
  
  def index
    @shown_projects = Project.where(:is_hidden => false)
    @center_coords = request.location.coordinates
    logger.info "@center_coords = #{@center_coords}"
    logger.info "request.location #{request.location.inspect}"
    @featured_projects = @shown_projects.where(:featured => true).limit(3)
    @local_projects = Project.near(@center_coords.reverse, 50, :units => :km).limit(3)  
    @coordinates = @featured_projects.collect {|project| 
      logger.info "featured Project ID = #{project.id}"
      logger.info "featured Project Title #{project.title}"
      c = project.coordinates.clone
      c << project.title }
    @coordinates.concat @local_projects.collect {|project| 
      logger.info "Local Project ID = #{project.id}"
      logger.info "Local Project Title #{project.title}"
      c = project.coordinates.clone 
      c << project.title }
  end
  
  def filter
    @projects = Project.all
  end
end
