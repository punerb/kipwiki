class ProjectsController < ApplicationController
  before_filter :load_project, :only => [:upload_attachment, :photos, :add_suggestion, :display, :show, :edit]
  before_filter :authenticate_user!, :only => [:create, :edit, :new, :update, :destroy] 
  before_filter :owner_required!, :only => [:edit, :update, :destroy] 
  
  layout "project_layout"
  def photos
  end

  def upload_attachment
    @print = @project.prints.new
    @print.attachment = params[:file] if params.has_key?(:file)
    # detect Mime-Type (mime-type detection doesn't work in flash)
    #@print.attachment_content_type = MIME::Types.type_for(params[:name]).to_s if params.has_key?(:name)
    @print.save!
    request.format = :js
    respond_to :js
  end

  def delete_attachment
    @print = Print.find(params[:print_id]) rescue nil
    @print.destroy if @print
    respond_to do |format|
      format.html{ redirect_to edit_project_path(@print.project.city, @print.project.slug)}
      format.js{ render :nothing }
    end
  end

  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    #this is some ugly ass code - but just temporary - until the view_count are initialized to 0
    @project.view_count.nil? ? @project.view_count = 0 : @project.view_count += 1
    @project.inc(:view_count, 1)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html {render 'new', :layout => 'admin' }# new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @selection = 'summary'
    @selection = params[:action_type] unless params[:action_type].nil?
    render 'edit', :layout => 'admin'
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    #Temporarily adding first user for project 
    #@project.user = User.first if User.first
    respond_to do |format|
      if @project.save
        format.html { redirect_to(show_project_path(@project.city.parameterize, @project.slug), :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new", :layout => 'admin' }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(show_project_path(@project.city.parameterize, @project.slug), :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  def add_suggestion
    @suggestion = @project.suggestions.new(params[:suggestion])
    logger.info("=========")
    logger.info(current_user.inspect)
    logger.info(session.inspect)
    @suggestion.user = current_user
    respond_to do |format|
      if @suggestion.save
        format.js { render :json => {:success => true} }
      else
        format.js { render :json => { :success => false }}
      end
    end
  end
  
  def search
    lat_lng = Geocoder.coordinates(params[:location])
    lat_lng = request.location.coordinates if lat_lng.nil? and request.ip == '127.0.0.1'
    p lat_lng

    #Geocoder finding record after reversing the lat-lng.So it will give 
    #wrong result if we dont reverse! DO NOT CHANGE - Jiren
     
    if lat_lng
      @projects = Project.near(lat_lng.reverse, 50, :units => :km)
      @coordinates = @projects.collect {|x| x.coordinates}
      @loc_center = Geocoder::Calculations.geographic_center(@coordinates) unless @coordinates.empty?
    else
      @projects = []
    end

    #Hack For rendering project type - Gautam
    @project = Project.new

    respond_to do |format|
      format.html
      format.json {render :json => @projects}
    end
  end

  def display
    @selection = 'summary'
    @selection = params[:action_type] unless params[:action_type].nil?
    render :display, :layout => "admin"
  end

  private

  def load_project
    if params[:city]
      @project = Project.where(:city => params[:city].titleize, :slug => params[:id]).first rescue nil
    else
      @project = Project.find(params[:id]) rescue nil
    end
    unless @project
      flash[:notice] = 'Invalid URL!!!'
      redirect_to request.referrer || projects_url
    end
  end
  
  def owner_required!
    unless @project.user == current_user
      flash[:error] = 'Unauthorized access.'
      redirect_to root_path
    end
  end
end
