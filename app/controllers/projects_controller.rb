class ProjectsController < ApplicationController
  before_filter :load_project, :only => [:upload_attachment, :photos, :add_suggestion, :display, :show, :edit, :followed_projects]
  before_filter :authenticate_user!, :only => [:create, :edit, :new, :update, :destroy, :add_suggestion] 
  before_filter :owner_required!, :only => [:edit, :destroy] 
  
  layout "project_layout"

  def admin_home
    @users = User.all 
    @projects = Project.all
    if !user_signed_in? || (user_signed_in? && current_user.is_admin == false)
      redirect_to  home_index_path
    else
      render :layout => "show_project_layout"
    end
  end
  
  def admin_users
    @users = User.where(:is_admin => false) 
    if !user_signed_in? || (user_signed_in? && current_user.is_admin == false)
      redirect_to  home_index_path
    else
      render :layout => "show_project_layout"
    end

  end  
  
  def search_projects
   keyword = params[:search].downcase.strip
   @projects = []
   @shown_projects = Project.where(:is_hidden => false)
   @shown_projects.each do |f|
     title = f.title.downcase
     city = f.city.downcase
     state = f.state.downcase
     country = f.country.downcase
     if (title == title.scan(/.*#{keyword}.*/).first || city == city.scan(/.*#{keyword}.*/).first || state == state.scan(/.*#{keyword}.*/).first || country == country.scan(/.*#{keyword}.*/).first)
       @projects << f
     end
   end

      @coordinates = @projects.collect{|x| x.coordinates}
      @loc_center = Geocoder::Calculations.geographic_center(@coordinates) unless @coordinates.empty?

   render  "search"
  end  

  def photos
  end
  
  def show_full_summary
    @project = Project.find(params[:id])
    respond_to do |format|
      format.js 
    end
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
    respond_to do |format|
      format.html { redirect_to home_index_path() }
      format.xml  { render :nothing }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    #this is some ugly ass code - but just temporary - until the view_count are initialized to 0
    @project.view_count.nil? ? @project.view_count = 0 : @project.view_count += 1
    @project.inc(:view_count, 1)
    respond_to do |format|
      format.html { render :layout => "show_project_layout"}# show.html.erb
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
    @project.user = current_user

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
        if current_user.is_admin == true
          format.html {redirect_to admin_home_path}
        else
          format.html { redirect_to(show_project_path(@project.city.parameterize, @project.slug), :notice => 'Project was successfully updated.') }
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_status
   is_hidden_hash = params[:is_hidden] || {}
   featured_hash = params[:featured] || {}
   
   is_hidden_hash.each_key do |id|
     project = Project.find(id)
     project.is_hidden = is_hidden_hash[id] == 'true' ? true : false
     project.save
   end 
   
   featured_hash.each_key do |id|
     project = Project.find(id)
     project.featured = featured_hash[id] == 'true' ? true : false
     project.save
   end 
   
    respond_to do |format|
        if current_user.is_admin == true
          format.html {redirect_to admin_home_path}
        else
          format.html { redirect_to(show_project_path(@project.city.parameterize, @project.slug), :notice => 'Project was successfully updated.') }
        end
        format.xml  { head :ok }
    end
  end

  def user_status
   is_blocked_hash = params[:is_blocked] || {}
   
   is_blocked_hash.each_key do |id|
     user = User.find(id)
     if is_blocked_hash[id] == "true"
       user.lock_access!
     else
       user.unlock_access!
     end 
     user.save
   end 
   
   
    respond_to do |format|
        if current_user.is_admin == true
          format.html {redirect_to admin_users_path}
        else
          format.html { redirect_to(show_project_path(@project.city.parameterize, @project.slug), :notice => 'Project was successfully updated.') }
        end
        format.xml  { head :ok }
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
    @suggestion = Suggestion.new(params[:suggestion])
    @suggestion.user_id = current_user.id
    respond_to do |format|
      if @project.suggestions << @suggestion 
        format.js { render :json => {:success => true} }
      else
        format.js { render :json => { :success => false }}
      end
    end
  end
  
  def search
    params[:search] = params[:location]
    search_projects
    # lat_lng = Geocoder.coordinates(params[:location])
    # lat_lng = request.location.coordinates if lat_lng.nil? and request.ip == '127.0.0.1'

    # #Geocoder finding record after reversing the lat-lng.So it will give 
    # #wrong result if we dont reverse! DO NOT CHANGE - Jiren

    # if lat_lng
    #   @projects = Project.near(lat_lng.reverse, 50, :units => :km) 
    #   @coordinates = @projects.collect {|x| x.coordinates } if !@projects.count == 0
    #   @loc_center = Geocoder::Calculations.geographic_center(@coordinates) unless (@coordinates.nil? || @coordinates.empty?)
    # else
    #   @projects = []
    # end

    # @projects  = [] if @projects.count == 0

    # #Hack For rendering project type - Gautam
    # @project = Project.new

    # respond_to do |format|
    #   format.html
    #   format.json {render :json => @projects}
    # end
  end

  def display
    @selection = 'summary'
    @selection = params[:action_type] unless params[:action_type].nil?
    render :display, :layout => "admin"
  end

  def dashboard 
    @user_projects = current_user.projects.where(:is_hidden => false)
    @followed_projects = current_user.followed_projects
    render "_dashboard", :layout => "show_project_layout"
  end
  

  def followed_projects
    @user_projects = current_user.projects
     is_followed = FollowedProject.where(:user_id => current_user.id , :project_id => @project.id).first
     if is_followed.nil?
       FollowedProject.create(:user_id => current_user.id, :project_id => @project.id)
       @selected = 'smallStar star_selected'
     else
       if Project.find(is_followed.project_id).user_id != current_user.id
	 is_followed.destroy 
	 @selected = 'smallStar deselected'
       else
         @selected = "smallStar star_selected"
       end 
     end

    @followed_projects = current_user.followed_projects 
    respond_to do |format|
      format.js { render "followed_projects"}
      format.html {redirect_to dashboard_path}
    end
  end

  def project_suggestions
    @project = Project.find(params[:id])
    type = params[:type]
    @unseen_suggestions = @project.suggestions.where(:is_viewed => false, :field_name => type)
    @unseen_suggestions.each do |f|
      f.is_viewed = true
      f.save
    end
    render :text => "Completed"
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
