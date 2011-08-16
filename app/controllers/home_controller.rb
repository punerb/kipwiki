class HomeController < ApplicationController
  
  layout "home_layout"
  
  def index
    @shown_projects = Project.where(:is_hidden => false)
    @center_coords = request.location.coordinates
    logger.info "@center_coords = #{@center_coords}"
    logger.info "request.location #{request.location.inspect}"
    logger.flush
debugger
    @featured_projects = @shown_projects.where(:featured => true).limit(3)
    @local_projects = Project.near(@center_coords.reverse, 50, :units => :km).limit(3)  
    logger.info "local_projects = #{@local_projects.length}"
    logger.info "featured_projects = #{@featured_projects.length}"
        logger.flush

    @coordinates = @featured_projects.collect {|project| 
      logger.info "featured Project ID = #{project.id}"
      logger.info "featured Project Title #{project.title}"
          logger.flush
      c = project.coordinates.clone
      c << project.title }
    if @local_projects.length > 0
      @coordinates.concat @local_projects.collect {|project| 
        logger.info "Local Project ID = #{project.id}"
        logger.info "Local Project Title #{project.title}"
            logger.flush
        c = project.coordinates.clone 
        c << project.title }
    end
  end
  
  def filter
    @projects = Project.all
  end
end
