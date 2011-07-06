class LinksController < ApplicationController
  # GET /links
  # GET /links.xml
  def index
    @links = Link.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @links }
    end
  end

  # GET /links/1
  # GET /links/1.xml
  def show
    @link = Link.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # GET /links/new
  # GET /links/new.xml
  def new
    @link = Link.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # GET /links/1/edit
  def edit
    @link = Link.find(params[:id])
  end

  # POST /links
  # POST /links.xml
  def create
    link = Link.new(params[:link])
    @project = Project.find(params[:project_id])
    @project.links << link
    respond_to do |format|
      if @project.save
        format.html { redirect_to(edit_project_by_action_type_path(@project, "link"), :notice => 'Link was successfully created.') }
        format.xml  { render :xml => @stakeholder, :status => :created, :location => @stakeholder }
      else
        format.html { redirect_to(edit_project_by_action_type_path(@project, "link"), :notice => "error while saving link") }
        format.xml  { render :xml => @stakeholder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.xml
  def update
    @link = Link.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(params[:link])
        format.html { redirect_to(@link, :notice => 'Link was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.xml
  def destroy
    @project = Project.find(params[:project_id])
    @project.links.find(params[:id]).delete

    respond_to do |format|
      format.html { redirect_to(links_url) }
      format.xml  { head :ok }
    end
  end
end
